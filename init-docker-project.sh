#!/usr/bin/env bash

mkdir .docker
cat << EOF > ./.docker/Dockerfile
FROM amazoncorretto:17-alpine3.19
RUN apk --update --no-cache add bash curl zip
RUN curl -s "https://get.sdkman.io" | bash
RUN bash -c "source \$HOME/.sdkman/bin/sdkman-init.sh && sdk install gradle"

WORKDIR /var/www

ADD gradle-init.sh /home/
RUN chmod +x /home/gradle-init.sh

ADD docker-init.sh /home/
RUN chmod +x /home/docker-init.sh
CMD bash /home/docker-init.sh
EOF

cat << EOF > ./.docker/gradle-init.sh
#!/usr/bin/env bash
echo "-------------------------------------------------------------------"
echo "-                create project with gradle                       -"
echo "-------------------------------------------------------------------"
gradle init \
  --type kotlin-application \
  --dsl kotlin \
  --test-framework junit-jupiter \
  --package nl.moukafih \
  --project-name my-project  \
  --no-split-project  \
  --java-version 17  <<< 'no'
  
EOF

cat << EOF > ./.docker/docker-init.sh
#!/usr/bin/env bash
# Add Gradle to the PATH
export PATH="\$PATH:\$HOME/.sdkman/candidates/gradle/current/bin"

gradle -v
# create new project if not exists
if [ ! -d "./app/src" ]; then
  . /home/gradle-init.sh
fi

gradle build
gradle run

tail -f /dev/null
EOF

cat << EOF > docker-compose.yml
version: '3.9'

services:
  app:
    user: root
    build:
      context: .docker
      dockerfile: Dockerfile
    volumes:
      - ./:/var/www
    tty: true
EOF

### Git
rm -rf .git
git init
git add init-docker-project.sh
git commit -m "init docker script"

git add .docker docker-compose.yml
git commit -m "add docker setup"

### Docker
docker compose up -d --build
docker logs demo-app-1
docker exec -it demo-app-1 bash
