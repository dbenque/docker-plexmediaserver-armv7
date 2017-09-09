FROM arm32v7/debian:jessie

# Download & install all required packages
RUN apt-get update; \
    apt-get install -y --no-install-recommends locales curl ca-certificates; \
    rm -rf /var/lib/apt/lists/*

# Locale needs to be set properly
RUN sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen && locale-gen

# Install Plex, source package for 'Synology ARMv7' from downloads page
ENV PLEX_PATH=/opt/plex/Application PLEX_VERSION=1.8.4.4249-3497d6779
RUN mkdir -p ${PLEX_PATH} \
 && curl https://downloads.plex.tv/plex-media-server/${PLEX_VERSION}/PlexMediaServer-${PLEX_VERSION}-arm7.spk | tar -xO package.tgz | tar -xz -C ${PLEX_PATH} \
 && mv ${PLEX_PATH}/Resources/start.sh ${PLEX_PATH}

ENV HOME=/config

VOLUME /config /media
EXPOSE 32400

WORKDIR ${PLEX_PATH}

# Container restarts don't work without this
RUN sed -i '2i rm -f /config/Library/Application\\ Support/Plex\\ Media\\ Server/plexmediaserver.pid' ${PLEX_PATH}/start.sh

CMD ["./start.sh"]
