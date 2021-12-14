#!/bin/bash

## Single platform
#docker build -t stepman0/sonos-kids-controller .

## Cross platform with buildx
docker buildx build \
    --platform linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64 \
    -t stepman0/sonos-kids-controller \
    --push \
    .
