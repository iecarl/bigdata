FROM ubuntu:22.04 AS unarchive

ARG HADOOP_VERSION
ARG HIVE_VERSION
ARG TEZ_VERSION 

COPY hadoop-$HADOOP_VERSION.tar.gz /opt
COPY apache-hive-$HIVE_VERSION-bin.tar.gz /opt
COPY apache-tez-$TEZ_VERSION-bin.tar.gz /opt
COPY JPam-Linux_amd64-1.1.tgz /opt


RUN tar -xzvf /opt/hadoop-$HADOOP_VERSION.tar.gz -C /opt/ && \
    rm -rf /opt/hadoop-$HADOOP_VERSION/share/doc/*
RUN tar -xzvf /opt/apache-hive-$HIVE_VERSION-bin.tar.gz -C /opt/ && \
    rm -rf /opt/apache-hive-$HIVE_VERSION-bin/jdbc/* 
RUN tar -xzvf /opt/apache-tez-$TEZ_VERSION-bin.tar.gz -C /opt && \
    rm -rf /opt/apache-tez-$TEZ_VERSION-bin/share/*
RUN tar -xzvf /opt/JPam-Linux_amd64-1.1.tgz -C /opt 

FROM openjdk:17-slim AS run

ARG HADOOP_VERSION
ARG HIVE_VERSION
ARG TEZ_VERSION

# Set necessary environment variables.
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION 
ENV HIVE_HOME=/opt/hive-$HIVE_VERSION 
ENV TEZ_HOME=/opt/tez-$TEZ_VERSION
ENV TEZ_FINAL_VERSION=$TEZ_VERSION
ENV TEZ_CLUSTER_HADOOP_APP=/apps/tez-$TEZ_VERSION/tez-$TEZ_VERSION-minimal.tar.gz

ENV HIVE_SERVER2_THRIFT_PORT=10000
ENV METASTORE_PORT=9083

ENV HADOOP_CLIENT_OPTS="-Xmx1G"
ENV HADOOP_CLIENT_OPTS="$HADOOP_CLIENT_OPTS -Djava.security.manager=allow"

ENV CORE_CONF_fs_defaultFS="file:///."

COPY --from=unarchive /opt/hadoop-$HADOOP_VERSION $HADOOP_HOME
COPY --from=unarchive /opt/apache-hive-$HIVE_VERSION-bin $HIVE_HOME
COPY --from=unarchive /opt/apache-tez-$TEZ_VERSION-bin $TEZ_HOME
COPY --from=unarchive /opt/JPam-1.1/libjpam.so $HADOOP_HOME/lib/native/libjpam.so

# Install dependencies
RUN set -ex; \
    apt-get -o Acquire::Max-FutureTime=86400 update; \
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

ENV HADOOP_CLASSPATH=$TEZ_CONF_DIR:$TEZ_HOME/*:$TEZ_HOME/lib/*
ENV PATH=$HIVE_HOME/bin:$HADOOP_HOME/bin:$PATH

COPY mysql-connector-j_8.0.33-1debian11_all.deb /opt
RUN apt install /opt/mysql-connector-j_8.0.33-1debian11_all.deb 
RUN ln -s /usr/share/java/mysql-connector-java-8.0.33.jar $HIVE_HOME/lib/mysql-connector-java.jar 
RUN rm /opt/mysql-connector-j_8.0.33-1debian11_all.deb 

COPY postgresql-42.7.8.jar $HIVE_HOME/lib/postgresql.jar 
RUN if [ -f "${HIVE_HOME}/lib/postgresql-9.4.1208.jre7.jar" ]; then rm $HIVE_HOME/lib/postgresql-9.4.1208.jre7.jar; fi

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

COPY run.sh /
RUN chmod +x /run.sh

RUN cp $HADOOP_HOME/share/hadoop/hdfs/lib/guava-27.0-jre.jar $HIVE_HOME/lib
RUN if [ -f "${HIVE_HOME}/lib/guava-19.0.jar" ]; then rm $HIVE_HOME/lib/guava-19.0.jar; fi
RUN if [ -f "${HIVE_HOME}/lib/guava-22.0.jar" ]; then rm $HIVE_HOME/lib/guava-22.0.jar; fi

EXPOSE 10000 10002 9083
ENTRYPOINT ["sh", "-c", "/entrypoint.sh /run.sh"]
