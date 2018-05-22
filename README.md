Credits to @viranch from which I forked that repo

[![Docker Pulls](https://img.shields.io/docker/pulls/dbenque/plex-armv7.svg?maxAge=604800)](https://hub.docker.com/r/dbenque/plex-armv7/) [![Docker Stars](https://img.shields.io/docker/stars/dbenque/plex-armv7.svg?maxAge=604800)](https://hub.docker.com/r/dbenque/plex-armv7/) [![Layers](https://images.microbadger.com/badges/image/dbenque/plex-armv7.svg)](https://hub.docker.com/r/dbenque/plex-armv7/)

# docker-plexmediaserver-armv7
Docker image for Plex Media Server for ARMv7

# Usage

## Public image

```
docker pull viranch/plex-armv7
```

## Build

```
git clone git://github.com/viranch/docker-plexmediaserver-armv7.git /tmp/pms-arm
cd /tmp/pms-arm
make  # builds image with name 'viranch/plex-armv7'
```

## Run

```
docker run -d --name plex --net=host -v /path/to/config:/config -v /path/to/media:/media viranch/plex-armv7
```

## Install


Installation using remote data: 
Create a folder called plex root.
There add 3 directories:
```
data
config
transcode
```
mount the data folder using /etc/fstab . In my case with a old syno:
```
192.168.0.16:/volume1/plexroot/data /home/pi/plexroot/data nfs nfsvers=3,_netdev,x-systemd.automount 0 0
```
(note the _netdev and x-systemd.automount to ensure a correct auto mount of ther remote fs)

The 2 other folders must be local to the machine for performances (plex won't even run in some case).
**The first time** launch the plex server using the launch script to use **host mode**. This is the only way I found so far to be able to boot the server and configure it the first time. For that provide a claim token ( https://www.plex.tv/claim/ ) as first parameter to the script.
Once the server is registered, it can then be launched in bridge mode, but the correct NAT must be done at the router level (freebox in my case).

For automatic restart, a systemd unit can be created ( /etc/systemd/system/plex.service ):
```
[Unit]
Description=Plex Media Server running in docker
After=docker.service
Requires=docker.service

[Service]
Restart=always
ExecStartPre=-/usr/bin/docker stop plex
ExecStartPre=-/usr/bin/docker rm plex
ExecStartPre=/usr/bin/docker pull dbenque/plex-armv7
ExecStart=/usr/bin/docker run --rm --name=plex -p 32400:32400/tcp -p 3005:3005/tcp -p 8324:8324/tcp -p 32469:32469/tcp -p 1900:1900/udp -p 32410:32410/udp -p 32412:32412/udp -p 32413:32413/udp -p 32414:32414/udp -e TZ="Europe/Paris" -e ADVERTISE_IP="http://88.173.33.36:32400/" -h dbenqueplex -v /home/pi/plexroot/config:/config -v /home/pi/plexroot/data:/data -v /home/pi/plexroot/transcode:/transcode dbenque/plex-armv7
ExecStop=/usr/bin/docker stop plex

[Install]
WantedBy=multi-user.target 
```

Then enable and launch the service:
```
sudo systemctl enable plex
sudo systemctl start plex
```
