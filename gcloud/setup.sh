#!/usr/bin/env bash

set -e

PROJECT_NAME=$1
CLUSTER_NAME=$2
CLUSTER_REGION=$3
CLUSTER_VERSION=$4
CLUSTER_NODE_VERSION=$5

if [[ -z $PROJECT_NAME ]]; then
  echo 'Please provide name for the project.'
  exit 1
elif [[ -z $CLUSTER_NAME ]]; then
  echo 'Please provide a name for the cluster.'
  exit 1
elif [[ -z $CLUSTER_REGION ]]; then
  echo 'Please provide a region for the cluster.'
  exit 1
elif [[ -z $CLUSTER_VERSION ]]; then
  echo 'Please provide a version for the cluster.'
  exit 1
elif [[ -z $CLUSTER_NODE_VERSION ]]; then
  echo 'Please provide a node version for the cluster.'
  exit 1
fi

GCLOUD_BIN_LOCATION=bin/gcloud/bin/gcloud

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

  ensure_tool_installed "gcloud" $GCLOUD_BIN_LOCATION 
}

main()
{
  ensure_tools_installed

  echo "Enabling Kubernetes Engine API..."
  $GCLOUD_BIN_LOCATION services enable container.googleapis.com

  echo "Creating Kubernetes cluster..."
  $GCLOUD_BIN_LOCATION container clusters create $CLUSTER_NAME \
      --project=$PROJECT_NAME \
      --cluster-version=$CLUSTER_VERSION \
      --region=$CLUSTER_REGION \
      --image-type=COS \
      --machine-type=n1-standard-4 \
      --num-nodes=1 \
      --min-nodes=1 \
      --max-nodes=2 \
      --scopes="https://www.googleapis.com/auth/cloud-platform" \
      --enable-ip-alias \
      --enable-autoscaling \
      --enable-stackdriver-kubernetes

      --preemptible \

  echo 'Finished creating K8s cluster '$CLUSTER_NAME' to be available...'
}

main