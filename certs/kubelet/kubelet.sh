#!/bin/sh

set -e

# List workers hostnames
WORKERS="${WORKERS:-worker1}"

for instance in $WORKERS; do
cat > ${instance}-csr.json <<EOF
{
  "CN": "system:node:${instance}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

INTERFACE="${INTERFACE:-eth1}"

echo "\n[*] Getting External IP From host: $instance ..\n"
EXTERNAL_IP=$(vagrant ssh $instance -c "ifconfig $INTERFACE | grep 'inet '" | awk -F'[: ]+' '{ print $4 }')
echo "\n\nExternal IP: $EXTERNAL_IP\n\n"

INTERNAL_IP=$EXTERNAL_IP

cfssl gencert \
  -ca=../ca/ca.pem \
  -ca-key=../ca/ca-key.pem \
  -config=../ca/ca-config.json \
  -hostname=${instance},${EXTERNAL_IP},${INTERNAL_IP} \
  -profile=kubernetes \
  ${instance}-csr.json | cfssljson -bare ${instance}
done