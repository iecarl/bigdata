#!/bin/bash

HADOOP_VERSION=3.3.1
# TEZ_VERSION=0.10.0

HADOOP_URL=${HADOOP_URL:-"https://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz"}
echo "Downloading Hadoop from $HADOOP_URL..."
if ! curl --fail -L "$HADOOP_URL" -o "hadoop-$HADOOP_VERSION.tar.gz"; then
  echo "Fail to download Hadoop, exiting...."
  exit 1
fi