#!/bin/bash

useradd -rm -d /home/$SSH_USER -s /bin/bash -g root -G sudo -u 1000 $SSH_USER
echo "$SSH_USER:$SSH_PASSWORD" | chpasswd

exec $@
