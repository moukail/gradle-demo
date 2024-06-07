FROM amazoncorretto:17-alpine3.19
RUN apk --update --no-cache add bash curl zip
RUN curl -s "https://get.sdkman.io" | bash
RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && sdk install gradle"

WORKDIR /var/www

ADD gradle-init.sh /home/
RUN chmod +x /home/gradle-init.sh

ADD docker-init.sh /home/
RUN chmod +x /home/docker-init.sh
CMD bash /home/docker-init.sh
