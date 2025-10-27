#!/bin/bash

set -x

: ${DB_DRIVER:=derby}

function initialize_hive {
  $HIVE_HOME/bin/schematool -initSchema -dbType $DB_DRIVER 
  if [ $? -eq 0 ]; then
    echo "Initialized schema successfully.."
    exit 0
  else
    echo "Schema initialization failed!"
    exit 1
  fi
}

function upgrade_hive {
  $HIVE_HOME/bin/schematool -upgradeSchema -dbType $DB_DRIVER 
  if [ $? -eq 0 ]; then
    echo "Upgrade schema successfully.."
    exit 0
  else
    echo "Schema upgrade failed!"
    exit 1
  fi
}

hdfs dfs -test -r /apps/tez-${TEZ_FINAL_VERSION}/tez-${TEZ_FINAL_VERSION}-minimal.tar.gz
if [ $? == 1  ]; then
  tar -cvzf /opt/tez-${TEZ_FINAL_VERSION}-minimal.tar.gz -C ${TEZ_HOME} . --xform 's/.\///'
  hdfs dfs -mkdir -p /apps/tez-${TEZ_FINAL_VERSION}
  hdfs dfs -put /opt/tez-${TEZ_FINAL_VERSION}-minimal.tar.gz ${TEZ_CLUSTER_HADOOP_APP}
  rm /opt/tez-${TEZ_FINAL_VERSION}-minimal.tar.gz
fi

if [ "${SERVICE_NAME}" == "hiveserver2" ]; then
  exec $HIVE_HOME/bin/hive --service $SERVICE_NAME
elif [ "${SERVICE_NAME}" == "metastore" ]; then
  exec $HIVE_HOME/bin/hive --service $SERVICE_NAME
elif [ "${SERVICE_NAME}" == "initschema" ]; then
  initialize_hive
elif [ "${SERVICE_NAME}" == "upgradeschema" ]; then
  upgrade_hive
else
  exec tail -f /dev/null 
fi


