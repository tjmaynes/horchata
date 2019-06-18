#!/usr/bin/env bash

if [ -z $SPINNAKER_CONFIG_FILE_NAME ]
then
  echo 'Please provide a file name to store spinnaker configuration.'
  exit 1
fi

if [ -z $SPINNAKER_STORAGE_BUCKET ]
then
  echo 'Please provide a bucket to store spinnaker configuration in.'
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
  echo 'Please provide a spinnaker service account json file.'
  exit 1
fi

cat > $SPINNAKER_CONFIG_FILE_NAME <<EOF 
storageBucket: $SPINNAKER_STORAGE_BUCKET
gcs:
  enabled: true
  project: $PROJECT_NAME
  jsonKey: '$(cat $SPINNAKER_SERVICE_ACCOUNT_JSON_FILE)' 
minio:
  enabled: false
accounts:
- name: gcr
  address: https://gcr.io
  username: $SPINNAKER_USERNAME
  password: '$(cat $SPINNAKER_SERVICE_ACCOUNT_JSON_FILE)'
  email: $SPINNAKER_EMAIL
EOF
