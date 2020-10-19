#!/bin/bash
sudo su
apt-get -y update
apt-get -y upgrade
apt-get -y install apache2
wget https://raw.githubusercontent.com/trilogy-group/sre-rwa/master/task1/index.html -O /var/www/html/index.html
sudo systemctl enable apache2
sudo systemctl restart apache2
