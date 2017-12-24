
#!/bin/sh

set -e

MASTER="${MASTER:-master1}"
INTERFACE="${INTERFACE:-eth1}"

echo "\n[*] Getting External IP From host: $MASTER ..\n"
KUBERNETES_PUBLIC_ADDRESS=$(vagrant ssh $MASTER -c "ifconfig $INTERFACE | grep 'inet '" | awk -F'[: ]+' '{ print $4 }')
echo "\n\nKubernetes Master IP: $KUBERNETES_PUBLIC_ADDRESS\n\n"

kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=../certs/ca/ca.pem \
  --embed-certs=true \
  --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443


kubectl config set-credentials admin \
  --client-certificate=../certs/admin/admin.pem \
  --client-key=../certs/admin/admin-key.pem

kubectl config set-context kubernetes-the-hard-way \
  --cluster=kubernetes-the-hard-way \
  --user=admin

kubectl config use-context kubernetes-the-hard-way
