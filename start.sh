#!/usr/bin/env bash

docker run --detach \
    --rm \
    --user root \
    --hostname="$(hostname)" \
    --publish="3389:3389/tcp" \
    --name="docker-desktop-xrdp" \
    docker-desktop-xrdp:latest
