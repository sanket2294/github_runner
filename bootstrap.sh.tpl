#!/bin/bash

# Variables
GITHUB_OWNER="${github_owner}"
GITHUB_REPO="${github_repo}"
GITHUB_TOKEN="${github_token}"

# Update and install necessary packages
sudo apt-get update
sudo apt-get install -y jq curl

# Download and install GitHub runner
mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-2.285.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.285.0/actions-runner-linux-x64-2.285.0.tar.gz
tar xzf ./actions-runner-linux-x64-2.285.0.tar.gz

# Configure the runner
./config.sh --url https://github.com/${GITHUB_OWNER}/${GITHUB_REPO} --token ${GITHUB_TOKEN}

# Install the service
sudo ./svc.sh install
sudo ./svc.sh start
