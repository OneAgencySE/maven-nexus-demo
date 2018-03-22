FROM jenkins/jenkins:lts

USER root
RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get -y install apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common && \
	curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
	add-apt-repository \
   	"deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   	$(lsb_release -cs) \
   	stable" && \
	apt-get update && \
	apt-get -y install docker-ce

# This is to run it on Mac. The 777 on docker.sock is a hack.
RUN gpasswd -a jenkins staff
# RUN chmod 777 /var/run/docker.sock

USER jenkins
RUN export DOCKER_HOST=unix:///var/run/docker.sock
