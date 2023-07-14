#!/bin/bash

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -x

export HADOOP_CLIENT_OPTS="$HADOOP_CLIENT_OPTS -Xmx1G"

if [ "${SERVICE_NAME}" == "namenode" ]; then
  namedir=`echo $HDFS_CONF_dfs_namenode_name_dir | perl -pe 's#file://##'`
  if [ ! -d $namedir ]; then
    echo "Namenode name directory not found: $namedir"
    exit 2
  fi
  if [ -z "$CLUSTER_NAME" ]; then
    echo "Cluster name not specified"
    exit 2
  fi
  if [ "`ls -A $namedir`" == "" ]; then
    echo "Formatting namenode name directory: $namedir"
    $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode -format $CLUSTER_NAME
  fi
  exec $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR $SERVICE_NAME
elif [ "${SERVICE_NAME}" == "datanode" ]; then
  datadir=`echo $HDFS_CONF_dfs_datanode_data_dir | perl -pe 's#file://##'`
  if [ ! -d $datadir ]; then
    echo "Datanode data directory not found: $datadir"
    exit 2
  fi
  exec $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR $SERVICE_NAME
elif [ "${SERVICE_NAME}" == "nodemanager" ]; then
  exec $HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR $SERVICE_NAME
elif [ "${SERVICE_NAME}" == "resourcemanager" ]; then
  exec $HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR $SERVICE_NAME  
elif [ "${SERVICE_NAME}" == "historyserver" ]; then
  exec $HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR $SERVICE_NAME  
fi