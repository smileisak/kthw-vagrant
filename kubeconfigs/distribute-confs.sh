#!/bin/sh

set -e

WORKERS="${WORKERS:-worker1}"
INTERFACE="${INTERFACE:-eth1}"



for instance in $WORKERS; do
  # gcloud compute scp ${instance}.kubeconfig kube-proxy.kubeconfig ${instance}:~/
  echo "\n[*] Getting External IP From host: $instance ..\n"
  instance_ip=$(vagrant ssh $instance -c "ifconfig $INTERFACE | grep 'inet '" | awk -F'[: ]+' '{ print $4 }')

  scp -i ../.vagrant/machines/${instance}/virtualbox/private_key \
                     kubelet/${instance}.kubeconfig \
                     kube-proxy/kube-proxy.kubeconfig \
                     vagrant@${instance_ip}:~/
done
