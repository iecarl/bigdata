#!/bin/bash

repo=localhost:5000
HADOOP_VERSION=3.3.1
TEZ_VERSION=0.10.2

docker build . \
    -f "Dockerfile" \
    -t "$repo/hadoop:$HADOOP_VERSION" \
    --build-arg "HADOOP_VERSION=$HADOOP_VERSION" \
    --build-arg "TEZ_VERSION=$TEZ_VERSION"