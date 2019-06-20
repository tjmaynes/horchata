#!/usr/bin/env bash

if [ -z $PROJECT_NAME ]
then
  echo 'Please provide name for the project.'
  exit 1
fi

if [ -z $SPINNAKER_CONFIG_FILE ]
then
  echo 'Please provide a config file location for Spinnaker.'
  exit 1
fi

if [ -z $SPINNAKER_USERNAME ]
then
  echo 'Please provide a username for Spinnaker.'
  exit 1
fi

if [ -z $SPINNAKER_EMAIL ]
then
  echo 'Please provide an email for Spinnaker.'
  exit 1
fi

if [ -z $SPINNAKER_SERVICE_ACCOUNT_JSON_FILE ]
then
  echo 'Please provide a json file with secrets for Spinnaker.'
  exit 1
fi

if [ -z $SPINNAKER_TIMEOUT ]
then
  echo 'Please provide a timeout for creating Spinnaker.'
  exit 1
fi

if [ -z $SPINNAKER_VERSION ]
then
  echo 'Please provide a version of Spinnaker to install.'
  exit 1
fi

if [ -z $SPINNAKER_STORAGE_BUCKET ]
then
  echo 'Please provide a storage bucket name for Spinnaker.'
  exit 1
fi

if [ -z $SPINNAKER_CHART_VERSION ]
then
  echo 'Please provide chart version to install Spinnaker.'
  exit 1
fi

if [ -z $SPINNAKER_NAMESPACE ]
then
  echo 'Please provide Kubernetes namespace name for Spinnaker.'
  exit 1
fi

# Create Spinnaker admin role binding
kubectl create clusterrolebinding \
    --clusterrole=cluster-admin \
    --serviceaccount=default:default spinnaker-admin

# Create Spinnaker namespace
kubectl create ns $SPINNAKER_NAMESPACE

# Create Spinnaker Config file
PROJECT_NAME=$PROJECT_NAME \
SPINNAKER_CONFIG_FILE_NAME=$SPINNAKER_CONFIG_FILE \
SPINNAKER_STORAGE_BUCKET=$SPINNAKER_STORAGE_BUCKET \
SPINNAKER_USERNAME=$SPINNAKER_USERNAME \
SPINNAKER_EMAIL=$SPINNAKER_EMAIL \
SPINNAKER_SERVICE_ACCOUNT_JSON_FILE=$SPINNAKER_SERVICE_ACCOUNT_JSON_FILE \
SPINNAKER_VERSION=$SPINNAKER_VERSION \
./spinnaker/create-config.sh

# Download local Spinnaker Helm chart
helm fetch --untar --untardir charts 'stable/spinnaker'

# Install Spinnaker via Helm
helm template charts/spinnaker \
    --name cd \
    --values $SPINNAKER_SERVICE_ACCOUNT_JSON_FILE \
    --namespace $SPINNAKER_NAMESPACE \
    | kubectl apply -f -
