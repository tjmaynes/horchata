#!/bin/bash

set -e

ensure_environment_variable_exists() {
  if [[ -z $1 ]]; then
    echo "Please check that '$2' exists as environment variable"
    exit 1
  fi
}

ensure_command_exists() {
  COMMAND=$1
  COMMAND_NAME=$2
  if [[ -z "$(command -v $COMMAND)" ]]; then
    echo 'Please install the '$COMMAND_NAME' tool.'
    exit 1
  fi
}
