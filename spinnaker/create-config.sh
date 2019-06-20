#!/usr/bin/env bash

if [ -z $PROJECT_NAME ]
then
  echo 'Please provide name for the project.'
  exit 1
fi

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

if [ -z $SPINNAKER_VERSION ]
then
  echo 'Please provide a spinnaker service account json file.'
  exit 1
fi

cat > $SPINNAKER_CONFIG_FILE_NAME <<EOF 
gcs:
  enabled: true
  bucket: $SPINNAKER_STORAGE_BUCKET
  project: $PROJECT_NAME
  jsonKey: '$(cat $SPINNAKER_SERVICE_ACCOUNT_JSON_FILE)' 
minio:
  enabled: false
dockerRegistries:
- name: gcr
  address: https://gcr.io
  username: $SPINNAKER_USERNAME
  password-file: '$(cat $SPINNAKER_SERVICE_ACCOUNT_JSON_FILE)'
  email: $SPINNAKER_EMAIL
halyard:
  spinnakerVersion: $SPINNAKER_VERSION
  image:
    tag: 1.12.0
  additionalScripts:
    create: true
    data:
      enable_gcs_artifacts.sh: |-
        \$HAL_COMMAND config artifact gcs account add gcs-$PROJECT_NAME --json-path /opt/gcs/key.json
        \$HAL_COMMAND config artifact gcs enable
      enable_pubsub_triggers.sh: |-
        \$HAL_COMMAND config pubsub google enable
        \$HAL_COMMAND config pubsub google subscription add gcr-triggers --subscription-name gcr-triggers --json-path /opt/gcs/key.json --project $PROJECT_NAME --message-format GCR
EOF
