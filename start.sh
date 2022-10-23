#!/bin/bash

sudo docker-compose pull

sudo docker-compose up --detach --force-recreate
