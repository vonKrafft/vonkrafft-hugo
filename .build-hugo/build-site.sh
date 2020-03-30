#!/bin/bash

cd "$(dirname "$0")"

HUGO_BASEURL="/"
HUGO_VERSION=$(grep "ENV HUGO_VERSION" Dockerfile | cut -d= -f2)

docker build -t vonkrafft/hugo:${HUGO_VERSION} .

cd ..

rm -r public/*
docker run -v "$(pwd):/site" vonkrafft/hugo:${HUGO_VERSION} -- --source /site --destination /site/public --cleanDestinationDir --baseURL "${HUGO_BASEURL}"
