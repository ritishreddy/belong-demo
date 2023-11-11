#!/bin/bash
sudo yum update -y
sudo yum install wget unzip httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime
sudo mkdir /var/www/html
sudo yum install -y aws-cli
aws s3 cp s3://belong-coding-challenge/belong-test.html /var/www/html/
