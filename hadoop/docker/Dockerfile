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
FROM ubuntu as unarchive

ARG HADOOP_VERSION

COPY hadoop-$HADOOP_VERSION.tar.gz /opt

RUN tar -xzvf /opt/hadoop-$HADOOP_VERSION.tar.gz -C /opt/ && \
    rm -rf /opt/hadoop-$HADOOP_VERSION/share/doc/* 

FROM openjdk:8-jre-slim AS run

ARG HADOOP_VERSION

# Set necessary environment variables.
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION 

COPY --from=unarchive /opt/hadoop-$HADOOP_VERSION $HADOOP_HOME

# Install dependencies
RUN set -ex; \
    apt-get update; \
    apt-get -y install procps; 

ENV HADOOP_CONF_DIR=/etc/hadoop
RUN cp -r $HADOOP_HOME/etc/hadoop /etc

ENV HDFS_CONF_dfs_namenode_name_dir=file:///hadoop/dfs/name
ENV HDFS_CONF_dfs_datanode_data_dir=file:///hadoop/dfs/data
ENV YARN_CONF_yarn_timeline___service_leveldb___timeline___store_path=/hadoop/yarn/timeline
ENV MULTIHOMED_NETWORK=1

ENV PATH=$HADOOP_HOME/bin:$PATH

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

COPY run.sh /
RUN chmod +x /run.sh

EXPOSE 9000 9870
ENTRYPOINT ["sh", "-c", "/entrypoint.sh /run.sh"]