#!/bin/sh

TAG=`git rev-parse --short HEAD`

cat Dockerrun.aws.json.template | sed 's|<TAG>|'$TAG'|g' > Dockerrun.aws.json
