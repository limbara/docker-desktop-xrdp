# docker-xrdp
Remote access to docker container using [xrdp](http://xrdp.org) running on ubuntu

use the following default user account details:

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