#!/usr/bin/env bash

if [ -z $SPINNAKER_NAMESPACE ]
then
  echo 'Please specify the namespace where Spinnaker lives on Kubernetes.'
  exit 1
fi

if [ -z $SPINNAKER_PORT ]
then
  echo 'Please specify a local port to forward remote Spinnaker calls through.'
  exit 1
fi

if [ -z $SPINNAKER_DECK_POD ]
then
  echo 'Please specify the pod identifier for Deck UI.'
  exit 1
fi

kubectl port-forward --namespace $SPINNAKER_NAMESPACE $SPINNAKER_DECK_POD $SPINNAKER_PORT:9000
