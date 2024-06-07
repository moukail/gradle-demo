#!/usr/bin/env bash
# Add Gradle to the PATH
export PATH="$PATH:$HOME/.sdkman/candidates/gradle/current/bin"

gradle -v
# create new project if not exists
if [ ! -d "./app/src" ]; then
  . /home/gradle-init.sh
fi

gradle build
gradle run

tail -f /dev/null
