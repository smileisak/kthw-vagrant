#!/bin/sh

set -e

cat > kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

INTERFACE="${INTERFACE:-eth1}"
MASTER="${MASTER:-master1}"

echo "\n[*] Getting External IP From host: $MASTER ..\n"
KUBERNETES_PUBLIC_ADDRESS=$(vagrant ssh $MASTER -c "ifconfig $INTERFACE | grep 'inet '" | awk -F'[: ]+' '{ print $4 }')
echo "\n\nKubernetes Master IP: $KUBERNETES_PUBLIC_ADDRESS\n\n"


cfssl gencert \
  -ca=../ca/ca.pem \
  -ca-key=../ca/ca-key.pem \
  -config=../ca/ca-config.json \
  -hostname=10.32.0.1,10.240.0.10,10.240.0.11,10.240.0.12,${KUBERNETES_PUBLIC_ADDRESS},127.0.0.1,kubernetes.default \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes