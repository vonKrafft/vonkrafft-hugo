#!/bin/bash
# usage: ./build-site.sh [BASEURL]

cd "$(dirname "$0")"

HUGO_BASEURL="${1:=/}"
HUGO_VERSION=$(grep "ENV HUGO_VERSION" Dockerfile | cut -d= -f2)

if [ -z $(docker image ls -q vonkrafft/hugo:${HUGO_VERSION}) ]; then
    docker build -t vonkrafft/hugo:${HUGO_VERSION} .
fi

cd ..

if [ -d "public" ]; then rm -r public; fi
docker run --rm -v "$(pwd):/site" vonkrafft/hugo:${HUGO_VERSION} -- --source /site --destination /site/public --cleanDestinationDir --baseURL "${HUGO_BASEURL}"
