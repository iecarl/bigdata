#!/bin/bash

repo=carlchung
HADOOP_VERSION=3.3.1

docker build . \
    -f "Dockerfile" \
    -t "$repo/hadoop:$HADOOP_VERSION" \
    --build-arg "HADOOP_VERSION=$HADOOP_VERSION" 