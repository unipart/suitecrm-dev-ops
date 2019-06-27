#!/bin/sh
#########################
# Author: Riccardo De Leo
#
# Description: Install docker and docker-compose on Fedora 30
# Note:        Please ensure your user has sudo capabilities
#########################

sudo dnf remove docker \
                docker-client \
                docker-client-latest \
                docker-common \
                docker-latest \
                docker-latest-logrotate \
                docker-logrotate \
                docker-selinux \
                docker-engine-selinux \
                docker-engine

sudo dnf -y install dnf-plugins-core

sudo dnf config-manager \
        --add-repo \
        https://download.docker.com/linux/fedora/docker-ce.repo

# 2019-06-25: At the moment we have to enable nightly package to use this with fedora
sudo dnf config-manager --set-enabled docker-ce-nightly

sudo dnf install docker-ce docker-ce-cli containerd.io

sudo systemctl enable docker

sudo systemctl start docker

sudo groupadd docker

sudo gpasswd -a ${USER} docker

sudo systemctl restart docker

newgrp docker

sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
