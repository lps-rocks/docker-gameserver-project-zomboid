FROM ghcr.io/parkervcp/steamcmd:debian

ENV SERVER_NAME=Pelican
ENV ADMIN_USER=admin
ENV ADMIN_PASSWORD=changeme
ENV MAX_PLAYERS=10
ENV SRCDS_APPID=380870
ENV SRCDS_BETAID=""
ENV STEAM_PORT=16262
ENV AUTO_UPDATE=1
ENV RCON_PORT=16261
ENV RCON_PASSWORD=rconpassword
ENV STARTUP='export PATH="./jre64/bin:$PATH" ; export LD_LIBRARY_PATH="./linux64:./natives:.:./jre64/lib/amd64:${LD_LIBRARY_PATH}" ; JSIG="libjsig.so" ; LD_PRELOAD="${LD_PRELOAD}:${JSIG}" ./ProjectZomboid64 -port {{SERVER_PORT}} -udpport {{STEAM_PORT}} -cachedir=/home/container/.cache -servername "{{SERVER_NAME}}" -adminusername {{ADMIN_USER}} -adminpassword "{{ADMIN_PASSWORD}}"'

VOLUME /home/container

USER root

COPY entrypoint.sh /entrypoint.sh
COPY healthcheck.sh /healthcheck.sh

RUN chmod +x /entrypoint.sh /healthcheck.sh

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        procps \
    && rm -rf /var/lib/apt/lists/*

USER container

ENTRYPOINT ["/entrypoint.sh"]

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD /healthcheck.sh
