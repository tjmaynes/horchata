#!/bin/bash

set -e

KUBECTL_VERSION=$1
HELM_VERSION=$2

if [[ -z $HELM_VERSION ]]; then
  echo "Please provide a version of helm to install."
  exit 1
elif [[ -z $KUBECTL_VERSION ]]; then
  echo "Please provide a version of kubectl to install."
  exit 1
fi

KUBECTL_BIN_LOCATION=bin/kubectl
HELM_BIN_LOCATION=bin/helm/helm

install_tool() {
  (mkdir -p bin/$2 || true) && curl -sL $1 >bin/$2.tar.gz
  tar -xf bin/$2.tar.gz -C bin/$2 --strip-components 1
  rm -rf bin/$2.tar.gz
  chmod +x $3
  sudo mv $3 /usr/local/bin
}

ensure_kubectl_installed() {
  if [[ -f $KUBECTL_BIN_LOCATION ]]; then
    echo "kubectl $KUBECTL_VERSION is already installed..."
  else
    echo "Installing 'kubectl' $KUBECTL_VERSION into bin/kubectl..."
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/darwin/amd64/kubectl" && mv kubectl bin/
    chmod +x $KUBECTL_BIN_LOCATION
  fi
}

ensure_helm_installed() {
  if [[ -f $HELM_BIN_LOCATION ]]; then
    echo "helm v$HELM_VERSION is already installed..."
  else
    echo "Installing helm v$HELM_VERSION into bin/helm..."
    install_tool "https://get.helm.sh/helm-v$HELM_VERSION-darwin-amd64.tar.gz" "helm" $HELM_BIN_LOCATION
  fi
}

main() {
  ensure_kubectl_installed
  ensure_helm_installed
}

main