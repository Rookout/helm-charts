#!/bin/sh
set -e
#set -o pipefail
echo '>> Prepare...'
mkdir -p /tmp/helm/bin
mkdir -p /tmp/helm/publish
apt update -y
apt install ca-certificates git openssh-server -y # Used to be just openssh

[ -z "$HELM_VERSION" ] && HELM_VERSION=2.8.1

echo '>> Installing Helm...'
cd /tmp/helm/bin
wget "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
tar -zxf "helm-v${HELM_VERSION}-linux-amd64.tar.gz"
chmod +x linux-amd64/helm
alias helm=/tmp/helm/bin/linux-amd64/helm
helm version -c
helm init -c --stable-repo-url https://charts.helm.sh/stable
