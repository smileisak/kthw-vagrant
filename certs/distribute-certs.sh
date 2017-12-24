#!/bin/sh

set -e

WORKERS="${WORKERS:-worker1}"
MASTERS="${MASTERS:-master1}"
INTERFACE="${INTERFACE:-eth1}"



for instance in $WORKERS; do
  #gcloud compute scp ca.pem ${instance}-key.pem ${instance}.pem ${instance}:~/
  echo "\n[*] Getting External IP From host: $instance ..\n"
  instance_ip=$(vagrant ssh $instance -c "ifconfig $INTERFACE | grep 'inet '" | awk -F'[: ]+' '{ print $4 }')

  scp -i ../.vagrant/machines/${instance}/virtualbox/private_key \
                     ca/ca.pem \
                     kubelet/${instance}-key.pem \
                     kubelet/${instance}.pem \
                     vagrant@${instance_ip}:~/
done


for instance in $MASTERS; do
    echo "\n[*] Getting External IP From host: $instance ..\n"
    instance_ip=$(vagrant ssh $instance -c "ifconfig $INTERFACE | grep 'inet '" | awk -F'[: ]+' '{ print $4 }')
    #gcloud compute scp ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem ${instance}:~/
    scp -i ../.vagrant/machines/${instance}/virtualbox/private_key \
                     ca/ca.pem \
                     ca/ca-key.pem \
                     api-server/kubernetes-key.pem \
                     api-server/kubernetes.pem  \
                     vagrant@${instance_ip}:~/

done