#!/bin/bash

# User to root
sudo su
cd ~

#
## Install NodeJS and verify its version
curl -fsSL https://deb.nodesource.com/setup_17.x | sudo -E bash -
apt-get install -y nodejs
npm install -g npm@8.5.0


# Install MySQL and verify its version
apt-get install mysql-server -y

# Clone movie-analyst-api repository
git clone https://github.com/MateoRincon04/movie-analyst-ui.git

# Install dependencies inside the project and configure database
cd m*

npm i express
npm i superagent

export BACK_HOST = "192.168.56.1"

# Run application
npm install -g pm2

pm2 delete all
pm2 start server.js