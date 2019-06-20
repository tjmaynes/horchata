#!/usr/bin/env bash

if [ -z $ISTIO_CHART_VERSION ]
then
  echo 'Please specify a Helm Istio chart version to use.'
  exit 1
fi

if [ -z $ISTIO_NAMESPACE ]
then
  echo 'Please specify a namespace for Istio on Kubernetes.'
  exit 1
fi

# Create Istio namespace
kubectl create namespace istio-system

# Add Istio Chart Repo
helm repo add istio.io https://storage.googleapis.com/istio-release/releases/$ISTIO_CHART_VERSION/charts/

# Download Istio Init Chart
helm fetch --untar --untardir charts 'istio.io/istio-init'

# Install Istio to Kubernetes namespace
helm template charts/istio-init \
    --name istio-init \
    --namespace $ISTIO_NAMESPACE \
    --set sidecarInjectorWebhook.enabled=false \
    --set grafana.enabled=true \
    --set servicegraph.enabled=true \
    | kubectl apply -f -
