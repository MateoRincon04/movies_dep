#!/bin/bash

# Install Nginx
apt-get install nginx -y

# Replacing nginx.conf and deleting unused file
cp -f /home/vagrant/nginx.conf /etc/nginx/nginx.conf
rm /home/vagrant/nginx.conf

# Restar Nginx service
systemctl restart nginx.service