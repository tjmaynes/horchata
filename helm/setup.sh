#!/usr/bin/env bash

set -e

SERVICE_USER=$1

if [[ -z $SERVICE_USER ]]; then
  echo 'Please provide user to allow credentials.'
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

  # Setup role binding for user-admin
  $KUBECTL_BIN_LOCATION create clusterrolebinding user-admin-binding \
      --clusterrole=cluster-admin \
      --user=$SERVICE_USER

  # Setup Service Account for Tiller, add role binding for tiller-admin
  $KUBECTL_BIN_LOCATION create serviceaccount tiller --namespace kube-system
  $KUBECTL_BIN_LOCATION create clusterrolebinding tiller-admin-binding \
      --clusterrole=cluster-admin \
      --serviceaccount=kube-system:tiller

  # Run Helm init and update repositories
  $HELM_BIN_LOCATION init \
      --service-account tiller \
      --tiller-namespace istio-system \
      --upgrade
  $HELM_BIN_LOCATION repo update

  # Wait for Tiller to be setup
  echo 'Wait for new Tiller service to be available...'
  sleep 40
  echo '...finished waiting!'
}

main
