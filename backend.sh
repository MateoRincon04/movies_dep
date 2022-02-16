#!/bin/bash

# User to root
sudo su
cd ~


# Verify git version
git --version
#
## Install NodeJS and verify its version
curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -
apt-get install -y nodejs
npm install -g npm@8.5.0


# Install MySQL and verify its version
apt-get install mysql-server -y

# Clone movie-analyst-api repository
git clone https://github.com/MateoRincon04/movie-analyst-api.git

# Install dependencies inside the project and configure database
cd m*


npm i express
npm i mysql
# npm i --package-lock-only

systemctl start mysql

#mysql
#CREATE DATABASE movies_db
#exit

mysql < data_model/table_creation_and_inserts.sql

systemctl enable mysql

# Run application
npm install -g pm2


pm2 start server.js
pm2 logs