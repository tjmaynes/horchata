#!/usr/bin/env bash

set -e

ISTIO_CHART_VERSION=$1
ISTIO_NAMESPACE=$2

if [[ -z $ISTIO_CHART_VERSION ]]; then
  echo 'Please specify a Helm Istio chart version to use.'
  exit 1
elif [[ -z $ISTIO_NAMESPACE ]]; then
  echo 'Please specify a namespace for Istio on Kubernetes.'
  exit 1
fi

KUBECTL_BIN_LOCATION=bin/kubectl
HELM_BIN_LOCATION=bin/helm/helm

ensure_tools_installed()
{
  ensure_tool_installed()
  {
      if [[ -f $2 ]]; then
        echo "$1 is already installed..."
      else
        echo "$1 is not installed!"
        exit 1
      fi
  }

  ensure_tool_installed "kubectl" $KUBECTL_BIN_LOCATION 
  ensure_tool_installed "helm" $HELM_BIN_LOCATION
}

main()
{
  ensure_tools_installed

  echo "Creating Istio namespace..."
  $KUBECTL_BIN_LOCATION create namespace istio-system

  echo "Adding Istio chart repo..."
  $HELM_BIN_LOCATION repo add istio.io https://storage.googleapis.com/istio-release/releases/$ISTIO_CHART_VERSION/charts/

  echo "Downloading Istio chart..."
  $HELM_BIN_LOCATION fetch --untar --untardir charts 'istio.io/istio-init'

  echo "Install Istio to Kubernetes namespace..."
  $HELM_BIN_LOCATION template charts/istio-init \
      --name istio-init \
      --namespace $ISTIO_NAMESPACE \
      --set sidecarInjectorWebhook.enabled=false \
      --set grafana.enabled=true \
      --set servicegraph.enabled=true \
      | $KUBECTL_BIN_LOCATION apply -f -
}

main