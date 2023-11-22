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
hadoop -- Apache Hadoop application installation
hive -- Apache Hive application installation
ldap -- OpenLDAP application installation 
mysql -- MySQL database server application installation
Zookeeper -- Apache Zookeeper application installation

The detail of the installation procedures for each application can be found in the application folder README.md file.
