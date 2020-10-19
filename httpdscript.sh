#!/bin/bash
sudo su
apt-get -y update
apt-get -y upgrade
apt-get -y install apache2
wget https://github.com/aigamal/Task1/raw/main/index.html -O /var/www/html/index.html
sudo systemctl enable apache2
sudo systemctl restart apache2
