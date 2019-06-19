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

if [ -z $SPINNAKER_SERVICE_ACCOUNT_NAME ]
then
  echo 'Please provide a service account name for Spinnaker.'
  exit 1
fi

if [ -z $SPINNAKER_USERNAME ]
then
  echo 'Please provide a username for spinnaker.'
  exit 1
fi

if [ -z $SPINNAKER_EMAIL ]
then
  echo 'Please provide an email for spinnaker.'
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

if [ -z $CLUSTER_REGION ]
then
  echo 'Please provide a region for the cluster.'
  exit 1
fi

# Create Spinnaker Service Account
gcloud iam service-accounts create $SPINNAKER_SERVICE_ACCOUNT_NAME \
    --project $PROJECT_NAME \
    --display-name $SPINNAKER_SERVICE_ACCOUNT_NAME

echo 'Wait for new Spinnaker service account to be available...'
sleep 40
echo '...finished waiting!'

# Set Spinnaker unique email
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

# Create Spinnaker admin role binding
kubectl create clusterrolebinding \
    --clusterrole=cluster-admin \
    --serviceaccount=default:default spinnaker-admin

# Create Spinnaker Service Account JSON file
gcloud iam service-accounts keys create $SPINNAKER_SERVICE_ACCOUNT_JSON_FILE \
    --iam-account $SPINNAKER_SERVICE_ACCOUNT_EMAIL

# Create Spinnaker Config file
PROJECT_NAME=$PROJECT_NAME \
SPINNAKER_CONFIG_FILE_NAME=$SPINNAKER_CONFIG_FILE \
SPINNAKER_STORAGE_BUCKET=$SPINNAKER_STORAGE_BUCKET \
SPINNAKER_USERNAME=$SPINNAKER_USERNAME \
SPINNAKER_EMAIL=$SPINNAKER_EMAIL \
SPINNAKER_SERVICE_ACCOUNT_JSON_FILE=$SPINNAKER_SERVICE_ACCOUNT_JSON_FILE \
SPINNAKER_VERSION=$SPINNAKER_VERSION \
./scripts/create-spinnaker-config.sh

# Create Spinnaker Storage Bucket
gsutil mb -c regional -l $CLUSTER_REGION gs://$SPINNAKER_STORAGE_BUCKET

# Create Spinnaker namespace
kubectl create ns $SPINNAKER_NAMESPACE

# Install Spinnaker via Helm
helm install -n cd stable/spinnaker \
    -f $SPINNAKER_SERVICE_ACCOUNT_JSON_FILE \
    --timeout $SPINNAKER_TIMEOUT \
    --version $SPINNAKER_CHART_VERSION \
    --namespace $SPINNAKER_NAMESPACE
