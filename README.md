# bigdata
The below prerequisite application installation are optional, please consider the purpose before to arrange the installations:
- MySQL -- manage Hive metadata database 
- OpenLDAP -- manage Hive authentication through LDAP server

Apache big data system contains below applications and the sequence of application installation should be as below:
1. Zookeeper
2. Hadoop
3. Hive

All application should be run in the same docker network, please run below script first before any application installation:
    sudo ./create_docker_network.sh
The "bigdata" docker network should be set after running the shell script

The folders for application docker container installation should be as below:
- hadoop -- Apache Hadoop application installation
- hive -- Apache Hive application installation
- ldap -- OpenLDAP application installation 
- mysql -- MySQL database server application installation
- zookeeper -- Apache Zookeeper application installation

## OpenLDAP  Server
Deploying a OpenLDAP Server docker container using docker-compose.yml file

The application data should be stored into mounted location. The below docker volume paths should be set:
- /var/lib/ldap -- OpenLDAP data directory
- /etc/ldap/slapd.d -- OpenLDAP configuration

The below environment variable should be updated:
- LDAP_ADMIN_PASSWORD -- Admin password for user initialization

## MySQL Database Server
Deploying a MySQL Database Server docker container using docker-compose.yml file

The application data should be stored into mounted location. The below docker volume paths should be set in the deployment file:
- /var/lib/mysql -- MySQL database directory

The below environment variable should be updated:
- MYSQL_ROOT_PASSWORD -- Password for root account

## Apache Zookeeper
Deploying a Apache Zookeeper docker container using docker-compose.yml file

The application data should be stored into mounted location. The below docker volume paths should be set in the deployment script:
- /data -- Zookeeper data
- /datalog -- Zookeeper data log

## Apache Hadoop
Deploying a Apache Hadoop docker container involves below procedures:
- Build hadoop container image
- Deploy hadoop components using docker-compose.yml file

### Build Docker Container Image
The docker container image building scripts can be found in hadoop/docker folder:
1. download.sh -- download specific version of Apache Hadoop for docker container image creation
2. build.sh -- build docker image after specific Apache Hadoop version zip file downloaded

The below parameters should be updated before building the docker image:
- HADOOP_VERSION -- The version number applied for creating Apache Hadoop docker image

The image name created shoud be in  [repo]/hadoop:[hadoop version applied]

### Run Docker Deployment
The docker-compose.yml file should be updated before deployment. Please make sure correct image is filled in the deployment file. 

The application data should be stored into mounted location. The below docker volume paths should be set:
- /hadoop/dfs/name -- the name node location
- /hadoop/dfs/data -- the data node location
- /hadoop/yarn/timeline -- the timeline location

The below Apache Hadoop components should be deployed in the deployment file:
- Name Node
- Data Node
- Node Manager
- Resource Manager
- History Server

The Apache Hadoop parameters are filed in hadoop.env file as environment variables. The environment variable prefixes represent:
- CORE_CONFIG_ -- core hadoop configuration found in core-site.xml
- HDFS_CONFIG_ -- Hadoop configuration found in hdfs-site.xml
- YARN_CONFIG_ -- Yarn configuration found in yarn-site.xml
- MAPRED_CONFIG_ -- Map reduce configuration found in mapred-site.xml

The parameters found in Apache Hadoop are transformed as environment variable by below rules:
- . is transformed as _
- @ is transformed as __
- - is transformed as ___ 
- _ is transformed as @
When the core-site.xml parameter is fs.defaultFS, the environment variable in hadoop.env file should be CORE_CONF_fs_defaultFS


## Apache Hive
Deploying a Apache Hive docker container involves below procedures:
- Build hive container image
- Deploy hive components using docker-compose.yml file

### Build Docker Container Image
The docker container image building scripts can be found in hive/docker folder:
1. download.sh -- download specific version of Apache Hadoop, Apache Hive and Apache Tez for docker container image creation
2. build.sh -- build docker image after specific Apache Hadoop, Apache Hive and Apache Tez zip files downloaded

The below parameters should be updated before building the docker image:
- HADOOP_VERSION -- The version number applied for Apache Hadoop 
- HIVE_VERSION -- The version number applied for Apache Hive 
- TEZ_VERSION -- The version number applied for Apache Tez 

The image name created shoud be in  [repo]/hive:[hive version applied]

### Run Docker Deployment
The docker-compose.yml file should be updated before deployment. Please make sure correct image is filled in the deployment file. 

The below Apache Hadoop components should be deployed in the deployment file:
- Hive Metastore
- Hive Server 2

The Apache Hadoop parameters are filed in hive.env file as environment variables. The environment variable prefixes represent:
- CORE_CONFIG_ -- core Hadoop configuration found in core-site.xml
- HDFS_CONFIG_ -- Hadoop configuration found in hdfs-site.xml
- YARN_CONFIG_ -- Yarn configuration found in yarn-site.xml
- MAPRED_CONFIG_ -- Map reduce configuration found in mapred-site.xml
- HIVE_CONFIG -- Hive configuration found in hive-site.xml
- HIVESERVER2_CONFIG -- Hive server 2 configuration found in hive-site.xml 
- HIVEMETASTORE_CONFIG -- Hive metastore configuration found in hive-site.xml 
- TEZ_CONFIG -- Tez configuration found in tez-site.xml

The parameters found in Apache Hadoop, Apache Hive and Apache Tez are transformed as environment variable by below rules:
- . is transformed as _
- @ is transformed as __
- - is transformed as ___ 
- _ is transformed as @
When the core-site.xml parameter is fs.defaultFS, the environment variable in hadoop.env file should be CORE_CONF_fs_defaultFS

## SSH Server in Ubuntu
Deploying a SSH Server in Ubuntu docker container involves below procedures:
- Build Ubuntu SSH container image
- Deploy Ubuntu SSH using docker-compose.yml file

### Build Docker Container Image
The docker container image building scripts can be found in ssh/docker folder:
1. download.sh -- download specific version of Ubuntu for docker container image creation
2. build.sh -- build docker image after specific Ubuntu zip files downloaded

The below parameters should be updated before building the docker image:
- UBUNTU_VERSION -- The version number applied for Ubuntu

The image name created shoud be in  [repo]/ubuntu-ssh-server:[Ubuntu version applied]

### Run Docker Deployment
The docker-compose.yml file should be updated before deployment. Please make sure correct image is filled in the deployment file. 

The below environment variable should be updated in docker compose file:
- SSH_USER -- User account for SSH connection
- SSH_PASSWORD -- Initial password for SSH connection

Please adjust the incoming port other than 22, the port setting example should be 2222:22.

# Docker Compose Deployment
Please run below command in the docker-compose.yml folder for docker container deployment:
docker compose up -d