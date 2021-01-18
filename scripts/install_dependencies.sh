#!/bin/bash

set -e

OS_TYPE=${OSTYPE//[0-9.]/}
KUBECTL_BIN_LOCATION=bin/kubectl
HELM_BIN_LOCATION=bin/helm
ISTIO_BIN_LOCATION=bin/istioctl

source ./scripts/common.sh

check_requirements() {
  ensure_environment_variable_exists "$HELM_VERSION" "HELM_VERSION"
  ensure_environment_variable_exists "$ISTIO_VERSION" "ISTIO_VERSION"
  ensure_environment_variable_exists "$KUBECTL_VERSION" "KUBECTL_VERSION"
}

ensure_kubectl_installed() {
  if [[ -f $KUBECTL_BIN_LOCATION ]]; then
    echo "kubectl $KUBECTL_VERSION is already installed: $KUBECTL_BIN_LOCATION"
  else
    echo "Installing 'kubectl' $KUBECTL_VERSION into $KUBECTL_BIN_LOCATION..."
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/$OS_TYPE/amd64/kubectl" && mv kubectl bin/
    chmod +x $KUBECTL_BIN_LOCATION
    rm -rf kubectl
  fi
}

ensure_helm_installed() {
  if [[ -f $HELM_BIN_LOCATION ]]; then
    echo "helm v$HELM_VERSION is already installed: $HELM_BIN_LOCATION"
  else
    echo "Installing helm v$HELM_VERSION into $HELM_BIN_LOCATION..."
    curl -sL "https://get.helm.sh/helm-v$HELM_VERSION-$OS_TYPE-amd64.tar.gz" >helm-$HELM_VERSION.tar.gz
    tar -xf helm-$HELM_VERSION.tar.gz --strip-components 1
    mv helm $HELM_BIN_LOCATION
    rm -rf helm-$HELM_VERSION.tar.gz $OS_TYPE-amd64 README.md
  fi
}

ensure_istio_installed() {
  if [[ -f $ISTIO_BIN_LOCATION ]]; then
    echo "istioctl v$ISTIO_VERSION is already installed: $ISTIO_BIN_LOCATION"
  else
    echo "Installing istio v$ISTIO_VERSION into $ISTIO_BIN_LOCATION..."
    curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION TARGET_ARCH=x86_64 sh -
    mv istio-$ISTIO_VERSION/bin/istioctl $ISTIO_BIN_LOCATION
    rm -rf istio-$ISTIO_VERSION
  fi
}

main() {
  check_requirements

  mkdir -p bin || true

  ensure_kubectl_installed
  ensure_helm_installed
  ensure_istio_installed
}

main
