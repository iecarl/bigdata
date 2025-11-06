#!/bin/bash

# Set some sensible defaults
export CORE_CONF_fs_defaultFS=${CORE_CONF_fs_defaultFS:-hdfs://`hostname -f`:9000}

function addProperty() {
  local path=$1
  local name=$2
  local value=$3

  local entry="<property><name>$name</name><value>${value}</value></property>"
  local escapedEntry=$(echo $entry | sed 's/\//\\\//g')
  sed -i "/<\/configuration>/ s/.*/${escapedEntry}\n&/" $path
}

function configure() {
    local path=$1
    local module=$2
    local envPrefix=$3

    local var
    local value
    
    echo "Configuring $module"
    for c in `printenv | perl -sne 'print "$1 " if m/^${envPrefix}_(.+?)=.*/' -- -envPrefix=$envPrefix`; do 
        name=`echo ${c} | perl -pe 's/___/-/g; s/__/@/g; s/_/./g; s/@/_/g;'`
        var="${envPrefix}_${c}"
        value=${!var}
        if [ "${name}" != "DIR" ]; then
            echo " - Setting $name=$value"
            addProperty $path $name "$value"
        fi
    done
}

configure /etc/hadoop/core-site.xml core CORE_CONF
configure /etc/hadoop/hdfs-site.xml hdfs HDFS_CONF
configure /etc/hive/hive-site.xml hive HIVE_CONF
if [ "${SERVICE_NAME}" == "metastore" ]; then
    configure /etc/hive/hive-site.xml metastore HIVEMETASTORE_CONF
elif [ "${SERVICE_NAME}" == "hiveserver2" ]; then
    configure /etc/hive/hive-site.xml hiveserver2 HIVESERVER2_CONF
fi
configure /etc/tez/tez-site.xml tez TEZ_CONF

exec $@
