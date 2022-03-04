#!/bin/bash

# User to root
sudo -E su
cd ~

# Environment variables
export NODE_ENV=production

# Install MySQL
apt-get update
apt-get install mysql-server -y

# Clone movie-analyst-api repository
[ ! -d "/root/movie-analyst-api" ] && git clone https://github.com/MateoRincon04/movie-analyst-api.git || echo "Git repository already cloned"
cd m*

# Install dependencies inside the project and configure database

[[ $(systemctl status mysql | grep -o “active”) != "active" ]] && systemctl start mysql || echo "MySQL esta activo"

mysql < data_model/table_creation_and_inserts.sql

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf

systemctl restart mysql