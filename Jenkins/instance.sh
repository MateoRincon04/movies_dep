#!/bin/bash

echo "PROVISIONING"

# Generate the inventory file to pass and add the bastion group with the bastion ip
echo -e "[instance]\n$1" > inventory

# Run ansible playbook
ansible-playbook -i ./inventory --private-key ~/.ssh/id_rsa -u ubuntu ./instance.yml

rm -f inventory
