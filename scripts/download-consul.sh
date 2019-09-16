#!/bin/bash

set -e

GPG_KEY=91A6E7F85D05C65630BEF18951852D87348FFC4C
KEY_SERVER=hkp://keyserver.ubuntu.com:80
CHECKPOINT_URL="https://checkpoint-api.hashicorp.com/v1/check"

if [ -z "${CONSUL_VERSION}" ]; then
    CONSUL_VERSION=$(curl -s "${CHECKPOINT_URL}"/consul | jq .current_version | tr -d '"')
fi

echo "Consul version: ${CONSUL_VERSION}"

gpg --keyserver "${KEY_SERVER}" --recv-keys "${GPG_KEY}"

echo "Downloading Consul binaries from releases.hashicorp.com..."
curl --silent --remote-name https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
curl --silent --remote-name https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS
curl --silent --remote-name https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS.sig

gpg --batch --verify consul_${CONSUL_VERSION}_SHA256SUMS.sig consul_${CONSUL_VERSION}_SHA256SUMS
grep consul_${CONSUL_VERSION}_linux_amd64.zip consul_${CONSUL_VERSION}_SHA256SUMS | sha256sum -c 

unzip -o consul_${CONSUL_VERSION}_linux_amd64.zip