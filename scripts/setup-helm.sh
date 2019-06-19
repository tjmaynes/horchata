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

# Download and install Helm
curl -LO https://storage.googleapis.com/kubernetes-helm/helm-v$HELM_VERSION-darwin-amd64.tar.gz
tar -zxvf helm-v$HELM_VERSION-darwin-amd64.tar.gz
chmod +x ./darwin-amd64/helm
mv ./darwin-amd64/helm /usr/local/bin/
rm -rf ./darwin-amd64

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
helm init --service-account=tiller --upgrade
helm update
