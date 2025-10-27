#!/bin/bash

repo=localhost:5000
HADOOP_VERSION=3.4.2
TEZ_VERSION=0.10.5

docker build . \
    -f "Dockerfile" \
    -t "$repo/hadoop:$HADOOP_VERSION" \
    --build-arg "HADOOP_VERSION=$HADOOP_VERSION" \
    --build-arg "TEZ_VERSION=$TEZ_VERSION"