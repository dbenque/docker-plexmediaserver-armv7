#!/bin/bash

#To buid uptodate image

#   git clone git://github.com/dbenque/docker-plexmediaserver-armv7.git /tmp/pms-arm
#   cd /tmp/pms-arm
#   make  # builds image with name 'viranch/plex-armv7'

# docker run \
# -d \
# --name plex \
# -p 32400:32400/tcp \
# -p 3005:3005/tcp \
# -p 8324:8324/tcp \
# -p 32469:32469/tcp \
# -p 1900:1900/udp \
# -p 32410:32410/udp \
# -p 32412:32412/udp \
# -p 32413:32413/udp \
# -p 32414:32414/udp \
# -e TZ="Europe/Paris" \
# -e PLEX_CLAIM="$1" \
# -e ADVERTISE_IP="http://192.168.0.33:32400/" \
# -h dbenqueplex \
# -v /home/pi/plexroot/config:/config \
# -v /home/pi/plexroot/transcode:/transcode \
# -v /home/pi/plexroot/data:/data \
# viranch/plex-armv7

docker run \
-d \
--name plex \
--network=host \
-e TZ="Europe/Paris" \
-e PLEX_CLAIM="$1" \
-v /home/pi/plexroot/config:/config \
-v /home/pi/plexroot/transcode:/transcode \
-v /home/pi/plexroot/data:/data \
dbenque/plex-armv7

