#!/usr/bin/env bash
# Run a mvn command in a Docker container
# https://store.docker.com/images/maven
dmvn() {
docker run -it --rm -v "$PWD":/usr/src/mymaven -v "$HOME/.m2":/root/.m2 -v "$PWD/target:/usr/src/mymaven/target" -w /usr/src/mymaven maven mvn $@;
}
