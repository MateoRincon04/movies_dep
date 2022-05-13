#!/bin/bash

echo "PROVISIONING --------------------------------"
ssh ${BASTION_HOST} -- ansible-playbook -i ~/movie_dep/IaC/Ansible/aws_ec2.yml -e "BACK_HOST=${BACK_HOST}" --private-key /home/ubuntu/.ssh/id_rsa -u ubuntu ~/movies_dep/Iac/Ansible/frontend.yml
echo "-------------------------------------"
