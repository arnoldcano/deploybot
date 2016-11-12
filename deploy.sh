#!/bin/sh

APP='deploybot'
TAG=`git rev-parse --short HEAD`

function check_environment() {
  echo 'Checking environment...'
  if [ -z "$DCOS_URL" ]; then
    echo 'DCOS_URL is not set'
    exit 1
  fi
  if [ -z "$DCOS_ACS_TOKEN" ]; then
    echo 'DCOS_ACS_TOKEN is not set'
    exit 1
  fi
  if [ -z "$HUBOT_SEMAPHOREAPP_AUTH_TOKEN" ]; then
    echo 'HUBOT_SEMAPHOREAPP_AUTH_TOKEN is not set'
    exit 1
  fi
  if [ -z "$HUBOT_SLACK_TOKEN" ]; then
    echo 'HUBOT_SLACK_TOKEN is not set'
    exit 1
  fi
}

function install_dcos_cli() {
  if ! type dcos > /dev/null; then
    echo 'Installing DCOS CLI...'
    curl -fLsS --retry 20 -Y 100000 -y 60 https://downloads.dcos.io/binaries/cli/linux/x86-64/dcos-1.8/dcos -o dcos
    sudo mv dcos /usr/local/bin
    sudo chmod +x /usr/local/bin/dcos
  fi
  dcos config set core.dcos_url $DCOS_URL
  dcos config set core.dcos_acs_token $DCOS_ACS_TOKEN
}

function generate_deploy_json() {
  echo 'Generating deploy json...'
  if [ ! -f "deploy.template.json" ]; then
    echo 'Deploy template json file not found'
    exit 1
  fi
  cat deploy.template.json \
    | sed "s|<TAG>|$TAG|g" \
    | sed "s|<HUBOT_SEMAPHOREAPP_AUTH_TOKEN>|$HUBOT_SEMAPHOREAPP_AUTH_TOKEN|g" \
    | sed "s|<HUBOT_SLACK_TOKEN>|$HUBOT_SLACK_TOKEN|g" \
    > $TAG.json
}

function deploy_to_dcos() {
  echo 'Deploying to DCOS...'
  if dcos marathon app show $APP 2>&1 | grep -q 'Error'; then
    dcos marathon app add < $TAG.json
  else
    dcos marathon app update $APP < $TAG.json
  fi
}

function cleanup_deploy_json() {
  echo 'Cleaning up deploy json...'
  if [ -f "$TAG.json" ]; then
    rm $TAG.json
  fi
}

check_environment
install_dcos_cli
generate_deploy_json
deploy_to_dcos
cleanup_deploy_json
