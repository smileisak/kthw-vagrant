#!/bin/sh

set -e

WORKERS="${WORKERS:-worker1}"
MASTER="${MASTER:-master1}"
INTERFACE="${INTERFACE:-eth1}"


echo "\n[*] Getting External IP From host: $MASTER ..\n"
KUBERNETES_PUBLIC_ADDRESS=$(vagrant ssh $MASTER -c "ifconfig $INTERFACE | grep 'inet '" | awk -F'[: ]+' '{ print $4 }')
echo "\n\nKubernetes Master IP: $KUBERNETES_PUBLIC_ADDRESS\n\n"

kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=../../certs/ca/ca.pem \
  --embed-certs=true \
  --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
  --kubeconfig=kube-proxy.kubeconfig

kubectl config set-credentials kube-proxy \
  --client-certificate=../../certs/kube-proxy/kube-proxy.pem \
  --client-key=../../certs/kube-proxy/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=kube-proxy.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=kube-proxy \
  --kubeconfig=kube-proxy.kubeconfig

kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
