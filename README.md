# Bugzilla4Intranet Docker image

Build it:

    docker build -t bugzilla4intranet .

Run it:

    docker run --name bz4i -p 8158:8157 -v /home/data -t -d bugzilla4intranet

Then point your browser to localhost:8158, login as admin@bugzilla.4intra.net
with 'bugzilla' password and configure your Bugzilla.

Please note that you should probably use SMTP to send email from inside of a
Docker container.

# Docker cheatsheet

Some basic commands to work with the resulting container:

* list running containers: `docker ps`
* list all containers: `docker ps -a`
* list system images: `docker images`
* stop container: `docker stop mw4i`
* start container again: `docker start mw4i`
* run shell in the container: `docker exec -it mw4i bash`
* remove container: `docker rm <container_id>`
* remove image: `docker rmi <image_id>`

P.S: If you get "Cannot connect to the Docker daemon. Is the docker daemon running on this host?" error,
add your system user into `docker` group **and relogin**!
