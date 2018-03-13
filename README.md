# Maven - Nexus Demo

A Small demo how Manven and Nexus is working together.

## Preparations

It is nice to have an IDE, such as IntelliJ, that can handle manen builds and profiles.

You should have Maven 3 and JDK8 installed on your local machine. Or use Docker Images, but
all command assumes that you have it installed localy.

### Start the servers.

I have prepared a Dockerfile to create a Jenkins Server image that can run Docker within Docker and 
a Docker Compose file that starts the two servers.

To start them, just run
```commandline
docker-compose up
```

This starts Jenkins on http://localhost:8080. Pay attention to the initial password string. You need
this to gain access to Jenkins the first time. I use admin/admin for this demo.

Nexus is started on http://localhost:8081 with default user/pass (admin/admin123).

## The Demo



