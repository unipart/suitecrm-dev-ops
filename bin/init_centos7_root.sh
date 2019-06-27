#!/bin/sh
#########################
# Author: Riccardo De Leo
#
# Description: Install docker and docker-compose on a CentOS 7 vm with root user
# Note:        Please ensure to change the place card <SPECIFY USER HERE> to the user that will run docker
#########################

yum update -y

yum remove -y docker \
                docker-client \
                docker-client-latest \
                docker-common \
                docker-latest \
                docker-latest-logrotate \
                docker-logrotate \
                docker-engine

yum install -y yum-utils \
    device-mapper-persistent-data \
    lvm2 \
    unzip

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

yum install -y docker-ce

systemctl start docker

usermod -aG docker <SPECIFY USER HERE>

curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose