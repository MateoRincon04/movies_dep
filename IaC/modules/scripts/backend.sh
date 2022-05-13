#!/bin/bash

#apt-get install python3-pip
#pip3 install --upgrade pip
#python3 -m pip install --user ansible

echo "PROVISIONING --------------------------------"
ssh ubuntu@${BASTION_HOST} -- ansible-playbook -i ~/movie_dep/IaC/Ansible/aws_ec2.yml -e "DB_PASS=${DB_PASS} DB_HOST=${DB_HOST}" --private-key /home/ubuntu/.ssh/id_rsa -u ubuntu ~/movies_dep/IaC/Ansible/backend.yml
echo "-------------------------------"
