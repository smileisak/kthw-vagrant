#!/bin/sh

set -xe 

cfssl gencert -initca ca-csr.json | cfssljson -bare ca
