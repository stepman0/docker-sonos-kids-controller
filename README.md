# Docker image for Sonos-Kids-Controller
## Sonos-Kids-Controller
Description of project see https://github.com/Thyraz/Sonos-Kids-Controller

## Docker
An easy and fast way to deploy Sonos-Kids-Controller is using docker. Using docker avoids the compilation on small hardware. This repository contains a Dockerfile to build a container image. 

The Dockerfile for node-sonos-http-api is here: https://github.com/chrisns/docker-node-sonos-http-api

Prebuild images are available on Dockerhub:
* [sonos-kids-controller](https://hub.docker.com/repository/docker/stepman0/sonos-kids-controller)
* [node-sonos-http-api](https://hub.docker.com/r/chrisns/docker-node-sonos-http-api/)

To use Sonos-Kids-Controller via Docker an a Raspberry Pi, the following steps are necessary:
1. Setup Raspberry Pi with Raspbian
2. Install Docker:
    ```
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    sudo usermod -aG docker pi
    ```
3. Install docker-compose:
    ```
    sudo apt-get install -y libffi-dev libssl-dev
    sudo apt-get install -y python3 python3-pip
    sudo pip3 -v install docker-compose
    ```
4. Create a docker-compose.yml:
```
version: "3"

services:
  api:
    image: "chrisns/docker-node-sonos-http-api"
    restart: unless-stopped
    network_mode: host
    volumes:
      - ./api/settings.json:/app/settings.json
      - ./api/clips:/app/static/clips
      - ./api/cache:/app/cache
      - ./api/presets:/app/presets

  controller:
    image: "stepman0/sonos-kids-controller"
    restart: unless-stopped
    network_mode: bridge
    ports:
      - 8200:8200
    volumes:
      - ./controller/config:/sonos-kids-controller/server/config/
```
5. Place the config files for the api (settings.json) in subdirectory ./api/settings and for the controller (config.json) in subdirectory ./controller/config
6. Start with `docker-compose up -d`
7. Setup local chromium (see instructions above)

ToDo: Add Chromium Kiosk in docker container.

## Known issues

If your container starts crashes with the following logs:

```
 #
 # Fatal error in , line 0
 # unreachable code
 #
 #
 #
 #FailureMessage Object: 0x.....

```

you need to upgrade libseccomp2. This issue arises from the Alpine base image - check [here](https://blog.samcater.com/fix-workaround-rpi4-docker-libseccomp2-docker-20/)

Run these commands on your Raspberry:
```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC 648ACFD622F3D138

echo 'deb http://httpredir.debian.org/debian buster-backports main contrib non-free' | sudo tee -a /etc/apt/sources.list.d/debian-backports.list

sudo apt update
sudo apt install libseccomp2 -t buster-backports
```
