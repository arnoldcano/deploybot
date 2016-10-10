#!/bin/sh

if [ -z "$HUBOT_SLACK_TOKEN" ]; then
  echo "HUBOT_SLACK_TOKEN is not set"
  exit 1
fi

if [ -z "$HUBOT_SEMAPHOREAPP_DEPLOY" ]; then
  echo "HUBOT_SEMAPHOREAPP_DEPLOY is not set"
  exit 1
fi

if [ -z "$HUBOT_SEMAPHOREAPP_AUTH_TOKEN" ]; then
  echo "HUBOT_SEMAPHOREAPP_AUTH_TOKEN is not set"
  exit 1
fi

if [ -z "$HUBOT_AUTH_ADMIN" ]; then
  echo "HUBOT_AUTH_ADMIN is not set"
  exit 1
fi

bin/hubot -a slack
