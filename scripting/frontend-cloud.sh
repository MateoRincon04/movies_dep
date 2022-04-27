#!/bin/bash

# User to root
sudo -E su
cd ~

## Install NodeJS and NPM
[[ $(dpkg-query -l nodejs | grep -o "17") != "17" ]] && curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash - || echo "NodeJS already installed"
apt-get install -y nodejs
[[ $(npm -v) != "8.5.4" ]] && npm install -g npm@8.5.4 || echo "NPM already updated"

# Clone movie-analyst-ui repository
[ ! -d "/root/movie-analyst-ui" ] && git clone https://github.com/MateoRincon04/movie-analyst-ui.git || echo "Git repository already cloned"
cd m*

# Environment variables
export NODE_ENV=production
export BACK_HOST=${BACK_HOST}

# Install dependencies inside the project and configure database
npm install

# Run application
[[ $(npm ls -g | grep pm2) == "" ]] && npm install -g pm2 || echo "PM2 already installed"
[[ $(pm2 status | grep -o "online") != "online" ]] && BACK_HOST=${BACK_HOST} NODE_ENV=production pm2 start server.js --update-env || echo "PM2 already running server.js"

sleep 1
echo "--------------------------------------------------------------------------------"
pm2 logs

