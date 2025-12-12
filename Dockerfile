FROM ghcr.io/parkervcp/steamcmd:debian

ENV SERVER_NAME=Pelican
ENV ADMIN_USER=admin
ENV ADMIN_PASSWORD=changeme
ENV MAX_PLAYERS=10
ENV SRCDS_APPID=380870
ENV SRCDS_BETAID=""
ENV STEAM_PORT=16262
ENV AUTO_UPDATE=1
ENV STARTUP='export PATH="./jre64/bin:$PATH" ; export LD_LIBRARY_PATH="./linux64:./natives:.:./jre64/lib/amd64:${LD_LIBRARY_PATH}" ; JSIG="libjsig.so" ; LD_PRELOAD="${LD_PRELOAD}:${JSIG}" ./ProjectZomboid64 -port {{SERVER_PORT}} -udpport {{STEAM_PORT}} -cachedir=/home/container/.cache -servername "{{SERVER_NAME}}" -adminusername {{ADMIN_USER}} -adminpassword "{{ADMIN_PASSWORD}}"'

VOLUME /home/container

COPY entrypoint.sh /entrypoint.sh
COPY healthcheck.py /healthcheck.py

RUN chmod +x /entrypoint.sh

# Install Python + pip
RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install the A2S query module
RUN pip3 install --break-system-packages python-a2s

ENTRYPOINT ["/entrypoint.sh"]

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD python3 /healthcheck.py
