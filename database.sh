#!/bin/bash

# User to root
sudo -E su
cd ~

## Install NodeJS and NPM
# [[ $(dpkg-query -l nodejs | grep -o "17") != "17" ]] && curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash - || echo "NodeJS already installed"
# apt-get install -y nodejs
# [[ $(npm -v) != "8.5.0" ]] && npm install -g npm@8.5.0 || echo "NPM already updated"

# Environment variables
export NODE_ENV=production

# Install MySQL
apt-get update
apt-get install mysql-server -y

# Clone movie-analyst-api repository
[ ! -d "/root/movie-analyst-api" ] && git clone https://github.com/MateoRincon04/movie-analyst-api.git || echo "Git repository already cloned"
cd m*

# Install dependencies inside the project and configure database
# npm install

[[ $(systemctl status mysql | grep -o “active”) != "active" ]] && systemctl start mysql || echo "MySQL esta activo"

mysql < data_model/table_creation_and_inserts.sql

# Run application
# [[ $(npm ls -g | grep pm2) == "" ]] && npm install -g pm2 || echo "PM2 already installed"
# [[ $(pm2 status | grep -o "online") != "online" ]] && pm2 start server.js || echo "PM2 already running server.js"