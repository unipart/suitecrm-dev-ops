#!/bin/sh
#########################
# Author: Riccardo De Leo
#
# Description: Install docker and docker-compose on a CentOS 7 vm
# Note:        Please ensure your user has sudo capabilities
#########################

DOCKER_COMPOSE_VERSION=1.25.4

sudo yum update -y

sudo yum remove -y docker \
                docker-client \
                docker-client-latest \
                docker-common \
                docker-latest \
                docker-latest-logrotate \
                docker-logrotate \
                docker-engine

sudo yum install -y yum-utils \
    device-mapper-persistent-data \
    lvm2 \
    unzip

sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install -y docker-ce

sudo systemctl start docker

sudo usermod -aG docker ${USER}

sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose