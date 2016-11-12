#!/bin/sh

NAME='deploybot'
TEMPLATE='deploy.template.json'
TAG=`git rev-parse --short HEAD`

install_dcos_cli() {
  if ! type dcos > /dev/null; then
    echo 'Installing DCOS CLI...'
    curl -fLsS --retry 20 -Y 100000 -y 60 https://downloads.dcos.io/binaries/cli/linux/x86-64/dcos-1.8/dcos -o dcos
    sudo mv dcos /usr/local/bin
    sudo chmod +x /usr/local/bin/dcos
  fi
  dcos config set core.dcos_url $DCOS_URL > /dev/null 2>&1
  dcos config set core.dcos_acs_token $DCOS_ACS_TOKEN > /dev/null 2>&1
}

check_environment() {
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
  install_dcos_cli
}

generate_deploy_json() {
  echo 'Generating deploy json...'
  if [ ! -f "deploy.template.json" ]; then
    echo 'Deploy template json file not found'
    exit 1
  fi
  cat $TEMPLATE \
    | sed "s|<TAG>|$TAG|g" \
    | sed "s|<HUBOT_SEMAPHOREAPP_AUTH_TOKEN>|$HUBOT_SEMAPHOREAPP_AUTH_TOKEN|g" \
    | sed "s|<HUBOT_SLACK_TOKEN>|$HUBOT_SLACK_TOKEN|g" \
    > $TAG.json
}

cleanup_deploy_json() {
  echo 'Cleaning up deploy json...'
  if [ -f "$TAG.json" ]; then
    rm $TAG.json
  fi
}

deploy_to_dcos() {
  generate_deploy_json
  echo 'Deploying to DCOS...'
  if dcos marathon app show $NAME 2>&1 | grep -q 'Error'; then
    dcos marathon app add < $TAG.json
  else
    dcos marathon app update $NAME < $TAG.json
  fi
  cleanup_deploy_json
}

check_environment
deploy_to_dcos
