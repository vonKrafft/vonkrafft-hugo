#!/bin/bash

cd "$(dirname "$0")"
HUGO_VERSION=$(grep "ENV HUGO_VERSION" Dockerfile | cut -d= -f2)
docker build -t vonkrafft/hugo:${HUGO_VERSION} .
