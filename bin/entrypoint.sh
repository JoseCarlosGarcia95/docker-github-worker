#!/bin/bash -x

set -e

cd /opt/actions-runner

# Get organization from repository url
ORGANIZATION=$(echo $REPOSITORY_URL | cut -d'/' -f4)
REPO=$(echo $REPOSITORY_URL | cut -d'/' -f5)

REG_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/repos/${ORGANIZATION}/${REPO}/actions/runners/registration-token | jq .token --raw-output)

./config.sh --url $REPOSITORY_URL --token $REG_TOKEN

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!