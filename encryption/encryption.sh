
#!/bin/sh

set -e

MASTERS="${MASTERS:-master1}"
INTERFACE="${INTERFACE:-eth1}"
ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)

cat > encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF




for instance in $MASTERS; do
  # gcloud compute scp ${instance}.kubeconfig kube-proxy.kubeconfig ${instance}:~/
  echo "\n[*] Getting External IP From host: $instance ..\n"
  instance_ip=$(vagrant ssh $instance -c "ifconfig $INTERFACE | grep 'inet '" | awk -F'[: ]+' '{ print $4 }')

  scp -i ../.vagrant/machines/${instance}/virtualbox/private_key \
                     encryption-config.yaml \
                     vagrant@${instance_ip}:~/
done
