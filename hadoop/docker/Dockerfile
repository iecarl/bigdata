FROM ubuntu:22.04 AS unarchive

ARG HADOOP_VERSION
ARG TEZ_VERSION 

COPY hadoop-$HADOOP_VERSION.tar.gz /opt
COPY apache-tez-$TEZ_VERSION-bin.tar.gz /opt

RUN tar -xzvf /opt/hadoop-$HADOOP_VERSION.tar.gz -C /opt/ && \
    rm -rf /opt/hadoop-$HADOOP_VERSION/share/doc/* 
RUN tar -xzvf /opt/apache-tez-$TEZ_VERSION-bin.tar.gz -C /opt && \
    rm -rf /opt/apache-tez-$TEZ_VERSION-bin/share/*

FROM eclipse-temurin:21-jdk AS run

ARG HADOOP_VERSION
ARG TEZ_VERSION

# Set necessary environment variables.
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION 
ENV TEZ_HOME=/opt/tez-$TEZ_VERSION
ENV TEZ_FINAL_VERSION=$TEZ_VERSION
ENV TEZ_CLUSTER_HADOOP_APP=/apps/tez-$TEZ_VERSION/tez-$TEZ_VERSION-minimal.tar.gz

COPY --from=unarchive /opt/hadoop-$HADOOP_VERSION $HADOOP_HOME
COPY --from=unarchive /opt/apache-tez-$TEZ_VERSION-bin $TEZ_HOME

# Install dependencies
RUN set -ex; \
    apt-get -o Acquire::Max-FutureTime=86400 update; \
    apt-get -y install procps; 

ENV HADOOP_CONF_DIR=/etc/hadoop
RUN cp -r $HADOOP_HOME/etc/hadoop /etc

ENV HDFS_CLIENT_OPTS="-Xmx1G"
ENV HDFS_CLIENT_OPTS="$HDFS_CLIENT_OPTS -Djava.security.manager=allow"
ENV HDFS_NAMENODE_OPTS="-Djava.security.manager=allow"
ENV HDFS_DATANODE_OPTS="-Djava.security.manager=allow"
ENV YARN_RESOURCEMANAGER_OPTS="-Djava.security.manager=allow"
ENV YARN_NODEMANAGER_OPTS="-Djava.security.manager=allow"
ENV YARN_HISTORYSERVER_OPTS="-Djava.security.manager=allow"
ENV MAPRED_CONF_yarn_app_mapreduce_am_env="HADOOP_MAPRED_HOME=/opt/hadoop-$HADOOP_VERSION/"
ENV MAPRED_CONF_mapreduce_map_env="HADOOP_MAPRED_HOME=/opt/hadoop-$HADOOP_VERSION/"
ENV MAPRED_CONF_mapreduce_reduce_env="HADOOP_MAPRED_HOME=/opt/hadoop-$HADOOP_VERSION/"

ENV HDFS_CONF_dfs_namenode_name_dir=file:///hadoop/dfs/name
ENV HDFS_CONF_dfs_datanode_data_dir=file:///hadoop/dfs/data
ENV YARN_CONF_yarn_timeline___service_leveldb___timeline___store_path=/hadoop/yarn/timeline

ENV TEZ_CONF_DIR=/etc/tez
RUN mkdir -p $TEZ_CONF_DIR
COPY tez-site.xml $TEZ_CONF_DIR

ENV HADOOP_CLASSPATH=$TEZ_CONF_DIR:$TEZ_HOME/*:$TEZ_HOME/lib/*
ENV PATH=$HADOOP_HOME/bin:$PATH

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

COPY run.sh /
RUN chmod +x /run.sh

EXPOSE 8030 8031 8032 8040 8042 8088 8188 9000 9864 9866 9867 9870 10200
ENTRYPOINT ["sh", "-c", "/entrypoint.sh /run.sh"]
