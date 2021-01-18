#!/bin/bash

set -e

source ./scripts/common.sh

check_requirements() {
  ensure_environment_variable_exists "SERVICE_USER" SERVICE_USER
  ensure_environment_variable_exists "$ISTIO_NAMESPACE" ISTIO_NAMESPACE
  ensure_environment_variable_exists "$TILLER_NAMESPACE" TILLER_NAMESPACE

  ensure_command_exists bin/kubectl kubectl
  ensure_command_exists bin/helm helm
  ensure_command_exists bin/istioctl istioctl
}

setup_helm() {
  if [[ -z $(bin/kubectl get clusterrolebinding | grep "cluster-admin") ]]; then
    bin/kubectl create clusterrolebinding user-admin-binding \
      --clusterrole=cluster-admin \
      --user=$SERVICE_USER
  fi

  if [[ -z $(bin/kubectl get serviceaccount --all-namespaces | grep "tiller") ]]; then
    bin/kubectl create serviceaccount tiller --namespace kube-system
  fi

  if [[ -z $(bin/kubectl get clusterrolebinding --all-namespaces | grep "tiller-admin-binding") ]]; then
    bin/kubectl create clusterrolebinding tiller-admin-binding \
      --clusterrole=cluster-admin \
      --serviceaccount=kube-system:tiller
  fi

  if [[ -z $(bin/kubectl get namespaces | grep "$TILLER_NAMESPACE") ]]; then
    bin/kubectl create namespace "$TILLER_NAMESPACE"
  fi

  bin/helm init \
    --service-account tiller \
    --tiller-namespace "$TILLER_NAMESPACE" \
    --upgrade

  bin/helm repo update
}

setup_istio() {
  bin/istioctl x precheck
}

main() {
  check_requirements

  setup_helm
  setup_istio
}

main
