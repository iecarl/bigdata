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
    apt-get -o Acquire::Max-FutureTime=86400 update; \
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
