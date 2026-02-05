#!/bin/bash

repo=localhost:5000

UBUNTU_VERSION=24.04

docker build . \
    -f "Dockerfile" \
    -t "$repo/dbclient:$UBUNTU_VERSION" \
