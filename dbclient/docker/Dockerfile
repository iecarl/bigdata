ARG UBUNTU_VERSION=24.04

FROM ubuntu:$UBUNTU_VERSION

RUN apt-get update 
RUN apt-get upgrade -y
RUN apt-get install -y apt-utils
RUN apt-get install -y curl 
RUN apt-get install -y openssh-server
RUN apt-get install -y sudo
RUN apt-get install -y lsb-release gnupg

RUN apt-get install -y mysql-client


RUN curl -sSL -O https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb 
RUN dpkg -i packages-microsoft-prod.deb 
RUN rm packages-microsoft-prod.deb
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y mssql-tools18 unixodbc-dev
RUN apt install -y dotnet-sdk-8.0
RUN /bin/bash -c "dotnet tool install -g microsoft.sqlpackage"
RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin:/root/.dotnet/tools"' > /etc/profile.d/mssql.sh

RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update
RUN apt-get -y install postgresql-client-18

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

COPY run.sh /
RUN chmod +x /run.sh

RUN mkdir /var/run/sshd

EXPOSE 22
ENTRYPOINT ["sh", "-c", "/entrypoint.sh /run.sh"]
