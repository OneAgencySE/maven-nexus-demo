# Maven - Nexus Demo

A Small demo how Manven and Nexus is working together.

## Preparations

It is nice to have an IDE, such as IntelliJ, that can handle Maven builds and profiles.

You should have Maven 3 and JDK8 installed on your local machine. Or use Docker Images, but
all command in this demo assumes that you have it installed. There is, however, a script (alias.sh) 
that creates a _dmvn_ command that works as _mvn_. Note that the Docker Maven can't do stuff like clean.

```commandline
source alias.sh
```

### Start the servers.

I have prepared a Dockerfile to create a Jenkins Server image that can run Docker within Docker and 
a Docker Compose file that starts the two servers.

To start them, just run
```commandline
docker-compose up
```

This step takes a while, so chill for a while.


This starts Jenkins on http://localhost:8080. Pay attention to the initial password string. You need
this to gain access to Jenkins the first time. I use admin/admin for this demo.

Nexus is started on http://localhost:8081 with default user/pass (admin/admin123).


## The Demo

In this demo, I have used the artifact _com.day.crx:crx-api:2.5.0_. Nevermind what is does, I used it because
it can not be found in the Central Repo. It is a part of the Adobe Experience Manager (AEM) toolbox. I just
needed it for demo purposes.

### Step 1 - Get it to build

Lets start with doing the command we all love.

```commandline
mvn clean install
``` 

It fails because we can't find that dependency. That one is deployed by Adobe in their repository that is
found at https://repo.adobe.com/nexus/content/groups/public.

I have create a profile in the pom, _abobe-public_, that points out this repository.

Let us run the command, but this time with this profile activated.

```commandline
mvn -Padobe-public clean install
```

Now it builds.

What is we wanted to use our local Nexus repository instead? The settings for that is done in the profile with id
_local-docker_. Let us try it. We need to remove the dependency from the local repo first. (The -U is to force update).

```commandline
rm -rf ~/.m2/repository/com/day/
mvn -U -Plocal-docker clean install
```

Nope, it doesn't work. That is because we have not added the Adobe Repository as a proxy to our local Nexus. Lets do that.

1. Login to Nexus as admin and click the little cog.
1. Select "Repositories"
1. Click "Create repository"
1. Select "maven2 (proxy)"
1. Enter "adobe-public-releases" as name
1. Enter "https://repo.adobe.com/nexus/content/groups/public" as URL.
1. Scroll down and hit "Create repository"
1. Select the "maven-public" repository.
1. Scroll down till you see the _Member repositories_ and add the Adobe Repo to members.
1. Save

Now, go back to the Browse Repositories (that is the box and then Browse). You should see all our repositories now. If you
look into the Adobe one, it should be empty.

Lets re-run the command.
```commandline
mvn -U -Plocal-docker clean install
```

Now it works. If you browse the Adobe Repo in Nexus now, you will notice
that it has downloaded it to the server with the dependencies needed. Now, the
Adobe Repo can go down and we can still build our application.

### Step 2 - Deploy it to Nexus

Nexus has two Maven repos by default; _maven-releases_ and _maven-snapshots_.
Let us try to deploy our artifact to the repo. The distribution management  settings is done in the profile _local-deploy_.

```commandline
mvn -Plocal-docker,local-deploy clean deploy
```

This fails... :( It failes because we don't have permissions to deploy to this server. You have to define the server
credentials in the settings.xml file. That is normaly found under ~/.m2/settings.xml and you should encrypt the passwords.
See https://maven.apache.org/guides/mini/guide-encryption.html.

I have created a settings.xml file with the default admin password to use. NEVER DO THIS IN REAL PROJECTS!!!

Run this command:
```commandline
mvn -Plocal-docker,local-deploy -s settings.xml clean deploy
```

You can now browse the maven-snapshots repository at http://localhost:8081/#browse/browse:maven-snapshots.

Run the command again.

And again...

In a Snapshot Repository, you can redeploy an artifact. 

### Step 3 - Release

Change the version to 1.0.0 and run the deploy command.

If we browse the http://localhost:8081/#browse/browse:maven-releases, we now find the 1.0.0 version of our artifact.

Try running the command again.

Ooops!! Failed. You can not re-deploy something that is released.

### Step 4 - Building this in Jenkins


You can point out this repository and make Jenkins build it. I do recommend that you fork it to your own
repository so that you can do releases on you own without disturbing the original repository.

Hint: if Jenkins can't build docker containers, it most likely is due to access rights to the socket.
To solve this, attach to the running Jenkins docker and change the settings of the socket.

```commandline
docker exec -it -u root mavennexusdemo_jenkins_1 bash
chmod 777 /var/run/docker.sock
```
