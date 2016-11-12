#!/bin/sh

NAME='deploybot'
TEMPLATE='deploy.template.json'
TAG=`git rev-parse --short HEAD`
DCOS_CLI_URL='https://downloads.dcos.io/binaries/cli/linux/x86-64/dcos-1.8/dcos'

check_environment() {
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

setup_dcos_cli() {
  if ! type dcos > /dev/null; then
    curl -fLsS --retry 20 -Y 100000 -y 60 $DCOS_CLI_URL -o dcos
    sudo mv dcos /usr/local/bin
    sudo chmod +x /usr/local/bin/dcos
  fi
  dcos config set core.dcos_url $DCOS_URL
  dcos config set core.dcos_acs_token $DCOS_ACS_TOKEN
}

prepare_deploy() {
  if [ ! -f "$TEMPLATE" ]; then
    echo "$TEMPLATE not found"
    exit 1
  fi
  cat $TEMPLATE \
    | sed "s|<TAG>|$TAG|g" \
    | sed "s|<HUBOT_SEMAPHOREAPP_AUTH_TOKEN>|$HUBOT_SEMAPHOREAPP_AUTH_TOKEN|g" \
    | sed "s|<HUBOT_SLACK_TOKEN>|$HUBOT_SLACK_TOKEN|g" \
    > $TAG.json
}

deploy_to_dcos() {
  if dcos marathon app show $NAME 2>&1 | grep -q 'Error'; then
    dcos marathon app add < $TAG.json
  else
    dcos marathon app update $NAME < $TAG.json
  fi
}

cleanup_deploy() {
  if [ -f "$TAG.json" ]; then
    rm $TAG.json
  fi
}

echo 'Checking environment...'
check_environment
echo 'Setup DCOS CLI...'
setup_dcos_cli
echo 'Preparing deploy...'
prepare_deploy
echo 'Deploying to DCOS...'
deploy_to_dcos
echo 'Cleanup deploy...'
cleanup_deploy
