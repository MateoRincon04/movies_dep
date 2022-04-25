#!/bin/bash

# User to root
sudo -E su
cd ~

## Install NodeJS and NPM
[[ $(dpkg-query -l nodejs | grep -o "17") != "17" ]] && curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash - || echo "NodeJS already installed"
apt-get install -y nodejs
[[ $(npm -v) != "8.5.4" ]] && npm install -g npm@8.5.4 || echo "NPM already updated"

# Clone movie-analyst-api repository
[ ! -d "/root/movie-analyst-api" ] && git clone https://github.com/MateoRincon04/movie-analyst-api.git || echo "Git repository already cloned"
cd m*

# Environment variables
export NODE_ENV=production
export DB_HOST=${DB_HOST}
export DB_USER="applicationuser"
export DB_PASS="applicationuser"
export DB_NAME="movie_db"
export PORT=3000

# Install dependencies inside the project and configure database
apt-get install mysql-client -y
[[ $(systemctl status mysql | grep -o “active”) != "active" ]] && systemctl start mysql || echo "MySQL esta activo"

mysql -h ${DB_HOST} -P 3306 -u $DB_USER --password=$DB_PASS < data_model/table_creation_and_inserts.sql

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf

systemctl restart mysql

npm install

# Run application
[[ $(npm ls -g | grep pm2) == "" ]] && npm install -g pm2 || echo "PM2 already installed"
[[ $(pm2 status | grep -o "online") != "online" ]] && NODE_ENV=production DB_USER="applicationuser" DB_NAME="movie_db" PORT=3000 DB_HOST=${DB_HOST} pm2 start server.js --update-env || echo "PM2 already running server.js"

 sleep 1
 echo "--------------------------------------------------------------------------------"
 pm2 logs
