#!/bin/bash

set -x

hdfs dfs -test -r /apps/tez-${TEZ_FINAL_VERSION}/tez-${TEZ_FINAL_VERSION}-minimal.tar.gz
if [ $? == 1  ]; then
  tar -cvzf /opt/tez-${TEZ_FINAL_VERSION}-minimal.tar.gz -C ${TEZ_HOME} . --xform 's/.\///'
  hdfs dfs -mkdir -p /apps/tez-${TEZ_FINAL_VERSION}
  hdfs dfs -put /opt/tez-${TEZ_FINAL_VERSION}-minimal.tar.gz ${TEZ_CLUSTER_HADOOP_APP}
  rm /opt/tez-${TEZ_FINAL_VERSION}-minimal.tar.gz
fi

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
elif [ "${SERVICE_NAME}" == "upgrade" ]; then
  exec $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode -upgrade
  exec hdfs dfsadmin -finalizeUpgrade
else
  exec tail -f /dev/null 
fi