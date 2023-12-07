ARG UBUNTU_VERSION

FROM ubuntu:$UBUNTU_VERSION

RUN apt-get update 
RUN apt-get install -y openssh-server

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

COPY run.sh /
RUN chmod +x /run.sh

RUN mkdir /var/run/sshd

EXPOSE 22
ENTRYPOINT ["sh", "-c", "/entrypoint.sh /run.sh"]
