#!/bin/bash

set -x

: ${DB_DRIVER:=derby}

SKIP_SCHEMA_INIT="${IS_RESUME:-false}"

function initialize_hive {
  $HIVE_HOME/bin/schematool -initSchema -dbType $DB_DRIVER 
  if [ $? -eq 0 ]; then
    echo "Initialized schema successfully.."
  else
    echo "Schema initialization failed!"
    exit 1
  fi
}

export HADOOP_CLIENT_OPTS="$HADOOP_CLIENT_OPTS -Xmx1G"
if [[ "${SKIP_SCHEMA_INIT}" == "false" ]]; then
  # handles schema initialization
  initialize_hive
fi

if [ "${SERVICE_NAME}" == "hiveserver2" ]; then
  export HADOOP_CLASSPATH=${TEZ_CONF_DIR}:${TEZ_HOME}/*:${TEZ_HOME}/lib/*:$HADOOP_CLASSPATH
elif [ "${SERVICE_NAME}" == "metastore" ]; then
  export METASTORE_PORT=${METASTORE_PORT:-9083}
fi

hdfs dfs -test -r /apps/tez-${TEZ_FINAL_VERSION}/tez-${TEZ_FINAL_VERSION}-minimal.tar.gz
if [ $? == 1  ]; then
  tar -cvzf /opt/tez-${TEZ_FINAL_VERSION}-minimal.tar.gz -C ${TEZ_HOME} . --xform 's/.\///'
  hdfs dfs -mkdir -p /apps/tez-${TEZ_FINAL_VERSION}
  hdfs dfs -copyFromLocal /opt/tez-${TEZ_FINAL_VERSION}-minimal.tar.gz /apps/tez-${TEZ_FINAL_VERSION}
  rm /opt/tez-${TEZ_FINAL_VERSION}-minimal.tar.gz
fi

exec $HIVE_HOME/bin/hive --service $SERVICE_NAME
