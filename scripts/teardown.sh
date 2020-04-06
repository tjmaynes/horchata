#!/usr/bin/env bash

set -e

PROJECT_NAME=$1
CLUSTER_NAME=$2
CLUSTER_REGION=$3

if [[ -z $PROJECT_NAME ]]; then
  echo 'Please provide name for the project.'
  exit 1
elif [[ -z $CLUSTER_NAME ]]; then
  echo 'Please provide a name for the cluster.'
  exit 1
elif [[ -z $CLUSTER_REGION ]]; then
  echo 'Please provide a region for the cluster.'
  exit 1
fi

GCLOUD_BIN_LOCATION=bin/gcloud/bin/gcloud

ensure_tools_installed()
{
  ensure_tool_installed()
  {
      if [[ -x "$(command -v $2)" ]]; then
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

  echo "Deleting Kubernetes cluster..."
  $GCLOUD_BIN_LOCATION container clusters delete $CLUSTER_NAME --region=$CLUSTER_REGION

  echo "TODO: Remove Kubernetes Load Balancers..."
  # https://stackoverflow.com/questions/48930737/how-to-delete-load-balancer-using-gcloud-command


  echo "Disabling Kubernetes Engine API..."
  $GCLOUD_BIN_LOCATION services disable container.googleapis.com
}

main