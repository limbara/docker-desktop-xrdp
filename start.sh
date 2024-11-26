#!/usr/bin/env bash

docker run --detach \
    --rm \
    --user root \
    --hostname="$(hostname)" \
    --publish="3389:3389/tcp" \
    --name="ubuntu-docker-desktop-xrdp" \
    ubuntu-docker-desktop-xrdp:latest
