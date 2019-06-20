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

if [ -z $SPINNAKER_SERVICE_ACCOUNT_NAME ]
then
  echo 'Please provide a service account name for Spinnaker.'
  exit 1
fi

if [ -z $SPINNAKER_SERVICE_ACCOUNT_JSON_FILE ]
then
  echo 'Please provide a json file with secrets for Spinnaker.'
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

# Create Spinnaker Storage Bucket
gsutil mb -c regional -l $CLUSTER_REGION gs://$SPINNAKER_STORAGE_BUCKET

# # Create Spinnaker Service Account
gcloud iam service-accounts create $SPINNAKER_SERVICE_ACCOUNT_NAME \
    --project $PROJECT_NAME \
    --display-name $SPINNAKER_SERVICE_ACCOUNT_NAME

echo 'Wait for new Spinnaker service account to be available...'
sleep 60
echo '...finished waiting!'

SPINNAKER_SERVICE_ACCOUNT_EMAIL=$(gcloud iam service-accounts list --filter="displayName:$SPINNAKER_SERVICE_ACCOUNT_NAME" --format='value(email)')

# Setup Pub-Sub to trigger Spinnaker pipelines
gcloud pubsub topics create projects/$PROJECT_NAME/topics/gcr
gcloud pubsub subscriptions create gcr-triggers \
    --topic projects/$PROJECT_NAME/topics/gcr
gcloud beta pubsub subscriptions add-iam-policy-binding gcr-triggers \
    --role roles/pubsub.subscriber \
    --member serviceAccount:$SPINNAKER_SERVICE_ACCOUNT_EMAIL

# Assign Spinnaker IAM roles
gcloud projects add-iam-policy-binding $PROJECT_NAME \
    --member serviceAccount:$SPINNAKER_SERVICE_ACCOUNT_EMAIL \
    --role roles/storage.admin
gcloud projects add-iam-policy-binding $PROJECT_NAME \
    --member serviceAccount:$SPINNAKER_SERVICE_ACCOUNT_EMAIL \
    --role roles/browser

# Create Spinnaker Service Account JSON file
gcloud iam service-accounts keys create $SPINNAKER_SERVICE_ACCOUNT_JSON_FILE \
    --iam-account $SPINNAKER_SERVICE_ACCOUNT_EMAIL
