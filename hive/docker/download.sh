#!/bin/bash

HIVE_VERSION=3.1.3
HADOOP_VERSION=3.3.1
TEZ_VERSION=0.10.0

HADOOP_URL=${HADOOP_URL:-"https://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz"}
echo "Downloading Hadoop from $HADOOP_URL..."
if ! curl --fail -L "$HADOOP_URL" -o "hadoop-$HADOOP_VERSION.tar.gz"; then
  echo "Fail to download Hadoop, exiting...."
  exit 1
fi

TEZ_URL=${TEZ_URL:-"https://archive.apache.org/dist/tez/$TEZ_VERSION/apache-tez-$TEZ_VERSION-bin.tar.gz"}
echo "Downloading Tez from $TEZ_URL..."
if ! curl --fail -L "$TEZ_URL" -o "apache-tez-$TEZ_VERSION-bin.tar.gz"; then
  echo "Failed to download Tez, exiting..."
  exit 1
fi

HIVE_URL=${HIVE_URL:-"https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz"}
echo "Downloading Hive from $HIVE_URL..."
if ! curl --fail -L "$HIVE_URL" -o "apache-hive-$HIVE_VERSION-bin.tar.gz"; then
  echo "Failed to download Hive, exiting..."
  exit 1
fi

MYSQL_CONNECTOR_URL=${MYSQL_CONNECTOR_URL:-"https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j_8.0.33-1debian11_all.deb"}
echo "Downloading MySQL Connector from $MYSQL_CONNECTOR_URL..."
if ! curl --fail -L "$MYSQL_CONNECTOR_URL" -o "mysql-connector-j_8.0.33-1debian11_all.deb"; then
  echo "Failed to download MySQL Connector, exiting..."
  exit 1
fi

JPAM_URL=${JPAM_URL:-"https://sourceforge.net/projects/jpam/files/jpam/jpam-1.1/JPam-Linux_amd64-1.1.tgz"}
echo "Downloading JPAM Connector from $JPAM_URL..."
if ! curl --fail -L "$JPAM_URL" -o "JPAM-Linux-amd64-1.1.tgz"; then
  echo "Failed to download JPAM Connector, exiting..."
  exit 1
fi