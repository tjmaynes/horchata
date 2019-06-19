#!/usr/bin/env bash

if [ -z $PROJECT_NAME ]
then
  echo 'Please provide name for the project.'
  exit 1
fi

if [ -z $CLUSTER_NAME ]
then
  echo 'Please provide a name for the cluster.'
  exit 1
fi

if [ -z $CLUSTER_REGION ]
then
  echo 'Please provide a region for the cluster.'
  exit 1
fi

# Enable Kubernetes Engine API
gcloud services enable container.googleapis.com

# Create Kubernetes Cluster
gcloud container clusters create $CLUSTER_NAME \
    --username="" \
    --node-version=$CLUSTER_VERSION \
    --machine-type=n1-standard-4 \
    --image-type=COS \
    --num-nodes=1 \
    --enable-autorepair \
    --enable-autoscaling \
    --enable-stackdriver-kubernetes \
    --min-nodes=1 \
    --max-nodes=2 \
    --region=$CLUSTER_REGION \
    --project=$PROJECT_NAME \
    --preemptible \
    --scopes="https://www.googleapis.com/auth/cloud-platform"
