# docker-xrdp
Remote access to docker container using [xrdp](http://xrdp.org) running on ubuntu

## To run the container

```bash
docker run --detach \
    --rm \
    --hostname="$(hostname)" \
    --publish="3389:3389/tcp" \
    --name="ubuntu-docker-desktop-xrdp" \
    limbara/ubuntu-docker-desktop-xrdp:latest
```

## Connect with an RDP client

For the hostname, use `localhost:3389` if the container is hosted on the same machine you're running your Remote Desktop client on and for remote connections use the name or IP address of the machine you are connecting to also it will require TCP port 3389 to be exposed through the firewall.

To log in, use the following default user account details:

```bash
Username: ubuntu
Password: ubuntu
```

## Building docker-desktop-xrdp on your own machine

First, clone the GitHub repository:

```bash
git clone https://github.com/limbara/docker-desktop-xrdp.git

cd docker-desktop-xrdp
```

You can then run the `docker build` command build or with the supplied script:

```bash
./build.sh
```

## Running local images with scripts

To start:

```bash
./start.sh
```

To stop:

```bash
./stop.sh
```