#!/bin/bash

repo=carlchung
HIVE_VERSION=3.1.3
HADOOP_VERSION=3.3.1
TEZ_VERSION=0.10.2

docker build . \
    -f "Dockerfile" \
    -t "$repo/hive:$HIVE_VERSION" \
    --build-arg "HIVE_VERSION=$HIVE_VERSION" \
    --build-arg "HADOOP_VERSION=$HADOOP_VERSION" \
    --build-arg "TEZ_VERSION=$TEZ_VERSION" 
