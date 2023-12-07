#!/bin/bash

repo=carlchung

UBUNTU_VERSION=22.04

docker build . \
    -f "Dockerfile" \
    -t "$repo/ubuntu-ssh-server:$UBUNTU_VERSION" \
    --build-arg "UBUNTU_VERSION=$UBUNTU_VERSION"  
