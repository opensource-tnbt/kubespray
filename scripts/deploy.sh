#!/bin/bash

cp -rfp inventory/sample inventory/oransc-cluster

declare -a IPS=($ANSIBLE_HOST_IP)
CONFIG_FILE=inventory/oransc-cluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
ansible-playbook -i inventory/oransc-cluster/hosts.yaml --become --become --become-user=root cluster.yml

sshpass -p $ANSIBLE_PASSWORD scp -o StrictHostKeyChecking=no -q root@$ANSIBLE_HOST_IP:/root/.kube/config ${PROJECT_ROOT}/kubeconfig
sed -i 's/127.0.0.1/$ANSIBLE_HOST_IP/g' "${PROJECT_ROOT}"/kubeconfig
