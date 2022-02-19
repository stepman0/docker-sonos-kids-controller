#!/bin/bash

## Cross platform with buildx
docker buildx build \
    --platform linux/amd64,linux/arm/v7,linux/arm64 \
    -t stepman0/sonos-kids-controller \
    --push \
    .
