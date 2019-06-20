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

if [ -z $SPINNAKER_STORAGE_BUCKET ]
then
  echo 'Please provide a storage bucket name for Spinnaker.'
  exit 1
fi

if [ -z $SPINNAKER_SERVICE_ACCOUNT_EMAIL ]
then
  echo 'Please provide a service account email for Spinnaker.'
  exit 1
fi

# Delete Kubernetes Cluster
gcloud container clusters delete $CLUSTER_NAME --region $CLUSTER_REGION

# Disable Kubernetes Engine API
gcloud services disable container.googleapis.com

# Remove Spinnaker storage bucket
gsutil rb -f gs://$SPINNAKER_STORAGE_BUCKET

# Remove Pub Sub
gcloud pubsub topics delete projects/$PROJECT_NAME/topics/gcr

# Remove service accounts
gcloud iam service-accounts delete $SPINNAKER_SERVICE_ACCOUNT_EMAIL
# gcloud projects remove-iam-policy-binding $CLUSTER_NAME --member=$SPINNAKER_SERVICE_ACCOUNT_EMAIL --role=browser
# gcloud projects remove-iam-policy-binding $CLUSTER_NAME --member=$SPINNAKER_SERVICE_ACCOUNT_EMAIL --role=storage.admin
