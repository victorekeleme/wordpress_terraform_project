#!/bin/bash

#Update System
sudo apt update

#Install Required packages
sudo apt install curl -y
sudo apt install wget -y
sudo apt install awscli -y
sudo apt install nfs-common -y
sudo apt install python3-pip -y
pip install boto3

#Install WordPress
curl -fsSL https://get.docker.com -o get-docker.sh
sh ./get-docker.sh
sudo curl -SL https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose

sudo usermod -aG docker ubuntu
sudo systemctl restart docker && sudo systemctl enable docker
sudo chmod 666 /var/run/docker.sock
sudo docker pull wordpress

#make mount point
sudo mkdir -p /var/www/html

sudo chmod go+rw /var/www/html

# Install Node exporter
sudo cd /opt/
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.4.0-rc.0/node_exporter-1.4.0-rc.0.linux-amd64.tar.gz

sudo tar xvzf node_exporter-1.4.0-rc.0.linux-amd64.tar.gz

sudo rm -rf node_exporter-*.tar.gz

sudo mv node_exporter-1.4.0-rc.0.linux-amd64/node_exporter /usr/local//bin/node_exporter

sudo useradd -rs /bin/false node_exporter

sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

#systemd
cat /home/ubuntu/node_exporter.service | sudo tee /etc/systemd/system/node_exporter.service

sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
sudo systemctl status node_exporter 