#!/bin/bash

repo=docker-registry.localhost

UBUNTU_VERSION=22.04

docker build . \
    -f "Dockerfile" \
    -t "$repo/dbclient:$UBUNTU_VERSION" \
    --build-arg UBUNTU_VERSION="$UBUNTU_VERSION"
