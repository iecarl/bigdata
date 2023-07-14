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
ARG HIVE_VERSION
ARG TEZ_VERSION 

COPY hadoop-$HADOOP_VERSION.tar.gz /opt
COPY apache-hive-$HIVE_VERSION-bin.tar.gz /opt
COPY apache-tez-$TEZ_VERSION-bin.tar.gz /opt
# COPY tez-$TEZ_VERSION-minimal.tar.gz /opt
COPY JPam-Linux_amd64-1.1.tgz /opt


RUN tar -xzvf /opt/hadoop-$HADOOP_VERSION.tar.gz -C /opt/ && \
    rm -rf /opt/hadoop-$HADOOP_VERSION/share/doc/*
RUN tar -xzvf /opt/apache-hive-$HIVE_VERSION-bin.tar.gz -C /opt/ && \
    rm -rf /opt/apache-hive-$HIVE_VERSION-bin/jdbc/* 
RUN tar -xzvf /opt/apache-tez-$TEZ_VERSION-bin.tar.gz -C /opt && \
    rm -rf /opt/apache-tez-$TEZ_VERSION-bin/share/*
# RUN mkdir -p /opt/tez-$TEZ_VERSION && \
#     tar -xzvf /opt/tez-$TEZ_VERSION-minimal.tar.gz -C /opt/tez-$TEZ_VERSION
RUN tar -xzvf /opt/JPam-Linux_amd64-1.1.tgz -C /opt 

FROM openjdk:8-jre-slim AS run

ARG HADOOP_VERSION
ARG HIVE_VERSION
ARG TEZ_VERSION

# Set necessary environment variables.
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION 
ENV HIVE_HOME=/opt/hive-$HIVE_VERSION 
ENV TEZ_HOME=/opt/tez-$TEZ_VERSION

COPY --from=unarchive /opt/hadoop-$HADOOP_VERSION $HADOOP_HOME
COPY --from=unarchive /opt/apache-hive-$HIVE_VERSION-bin $HIVE_HOME
COPY --from=unarchive /opt/apache-tez-$TEZ_VERSION-bin $TEZ_HOME
# COPY --from=unarchive /opt/tez-$TEZ_VERSION $TEZ_HOME
COPY --from=unarchive /opt/JPam-1.1/libjpam.so $HADOOP_HOME/lib/native/libjpam.so

# Install dependencies
RUN set -ex; \
    apt-get update; \
    apt-get -y install procps; 

ENV HADOOP_CONF_DIR=/etc/hadoop
RUN cp -r $HADOOP_HOME/etc/hadoop /etc

ENV HIVE_CONF_DIR=/etc/hive
RUN mkdir -p $HIVE_CONF_DIR
RUN cp $HIVE_HOME/conf/ivysettings.xml $HIVE_CONF_DIR
RUN cp $HIVE_HOME/conf/parquet-logging.properties $HIVE_CONF_DIR
COPY hive-site.xml $HIVE_CONF_DIR
COPY hivemetastore-site.xml $HIVE_CONF_DIR
COPY hiveserver2-site.xml $HIVE_CONF_DIR

ENV TEZ_CONF_DIR=/etc/tez
RUN mkdir -p $TEZ_CONF_DIR
COPY tez-site.xml $TEZ_CONF_DIR

ENV PATH=$HIVE_HOME/bin:$HADOOP_HOME/bin:$PATH

COPY mysql-connector-j_8.0.33-1debian11_all.deb /opt
RUN apt install /opt/mysql-connector-j_8.0.33-1debian11_all.deb 
RUN ln -s /usr/share/java/mysql-connector-java-8.0.33.jar $HIVE_HOME/lib/mysql-connector-java.jar 
RUN rm /opt/mysql-connector-j_8.0.33-1debian11_all.deb 

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

COPY run.sh /
RUN chmod +x /run.sh

RUN cp $HADOOP_HOME/share/hadoop/hdfs/lib/guava-27.0-jre.jar $HIVE_HOME/lib && \
    rm $HIVE_HOME/lib/guava-19.0.jar

# RUN adduser --no-create-home --disabled-login --gecos "" --uid $UID hive && \
#     chown hive $TEZ_HOME && \
#     chown hive $HIVE_HOME && \
#     chown hive $HADOOP_HOME && \
#     chown hive $HADOOP_HOME/etc/hadoop && \
#     chown hive $HIVE_HOME/conf 

# USER hive
# WORKDIR $HIVE_HOME
EXPOSE 10000 10002 9083
ENTRYPOINT ["sh", "-c", "/entrypoint.sh /run.sh"]