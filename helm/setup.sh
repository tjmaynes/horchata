#!/usr/bin/env bash

if [ -z $HELM_VERSION ]
then
  echo 'Please specify a Helm version to download.'
  exit 1
fi

if [ -z $SERVICE_USER ]
then
  echo 'Please provide user to allow cred.'
  exit 1
fi

# Setup role binding for user-admin
kubectl create clusterrolebinding user-admin-binding \
    --clusterrole=cluster-admin \
    --user=$SERVICE_USER

# Setup Service Account for Tiller, add role binding for tiller-admin
kubectl create serviceaccount tiller --namespace kube-system
kubectl create clusterrolebinding tiller-admin-binding \
    --clusterrole=cluster-admin \
    --serviceaccount=kube-system:tiller

# Run Helm init and update repositories
helm init \
    --service-account tiller \
    --tiller-namespace istio-system \
    --upgrade
helm repo update

# Wait for Tiller to be setup
echo 'Wait for new Tiller service to be available...'
sleep 40
echo '...finished waiting!'
