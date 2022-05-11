#!/bin/bash

# scp ubuntu@$BASTION_HOST:~/movies_dep/IaC/Ansible ~/Ansible

echo "PROVISIONING --------------------------------"
echo "${BASTION_HOST}"
echo "---------------------------------------------"
ssh ${BASTION_HOST} -- ansible-playbook -i ~/movie_dep/IaC/Ansible/aws_ec2.yml -e "DB_PASS=${DB_PASS} DB_HOST=${DB_HOST}" --private-key /home/ubuntu/.ssh/id_rsa -u ubuntu ~/movies_dep/IaC/Ansible/backend.yml
echo "-------------------------------"
