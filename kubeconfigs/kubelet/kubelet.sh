#!/bin/sh

set -e

WORKERS="${WORKERS:-worker1}"
MASTER="${MASTER:-master1}"
INTERFACE="${INTERFACE:-eth1}"

echo "\n[*] Getting External IP From host: $MASTER ..\n"
KUBERNETES_PUBLIC_ADDRESS=$(vagrant ssh $MASTER -c "ifconfig $INTERFACE | grep 'inet '" | awk -F'[: ]+' '{ print $4 }')
echo "\n\nKubernetes Master IP: $KUBERNETES_PUBLIC_ADDRESS\n\n"

for instance in $WORKERS; do
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=../../certs/ca/ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-credentials system:node:${instance} \
    --client-certificate=../../certs/kubelet/${instance}.pem \
    --client-key=../../certs/kubelet/${instance}-key.pem \
    --embed-certs=true \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:node:${instance} \
    --kubeconfig=${instance}.kubeconfig

  kubectl config use-context default --kubeconfig=${instance}.kubeconfig
done