#!/usr/bin/env bash

cd /tmp

sudo yum -y install unzip
sudo yum -y install wget
sudo yum -y install tree
sudo yum -y install ansible
sudo yum -y install vim

#install ansible
sudo wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo rpm -i epel-release-latest-7.noarch.rpm
sudo yum -y install ansible

#install aws-cli
sudo wget https://s3.amazonaws.com/aws-cli/awscli-bundle.zip
unzip awscli-bundle.zip
./awscli-bundle/install -b ~/bin/aws

sleep 5s
aws s3 --region=eu-west-2 cp s3://com.clearafix/images/test.txt .

echo -e "localhost ansible_connection=local" >> /etc/ansible/hosts

ansible-playbook install_nginx.yml