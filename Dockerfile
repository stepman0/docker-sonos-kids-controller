#####
# Stage 1: Build ionic
#####
FROM node:16 as build

WORKDIR /sonos-kids-controller

## Install ionic
RUN npm install -g @ionic/cli

## Install dependencies
COPY src/package.json /sonos-kids-controller/package.json
RUN npm install 

## Copy source code
COPY src /sonos-kids-controller

## Build Sonos Kids Controller
RUN ionic build --prod

#####
# Stage 2: package
#####
FROM node:16 

WORKDIR /sonos-kids-controller

## Install dependencies
COPY src/package.json /sonos-kids-controller/package.json
RUN npm install --production

## Copy source code
COPY src /sonos-kids-controller
COPY --from=build /sonos-kids-controller/www/ /sonos-kids-controller/www/

## Config directory should be stored in a volume
VOLUME /sonos-kids-controller/server/config

## Expose service on port 8200
EXPOSE 8200

## Do not run as root user
USER node

## Start 
CMD npm start
