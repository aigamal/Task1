sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install apache2
cd /var/www/html/
sudo rm index.html
sudo wget https://github.com/aigamal/Task1/raw/main/index.html
sudo systemctl enable apache2
sudo systemctl restart apache2

