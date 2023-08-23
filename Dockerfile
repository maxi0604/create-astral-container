FROM eclipse-temurin:17-jre-jammy
RUN apt-get -qq update && apt-get -qq install -y unzip jq

RUN curl -fsSL -o "/tmp/rcon.tar.gz" $(curl -s https://api.github.com/repos/gorcon/rcon-cli/releases/latest | jq -r '.assets | map(select(.name | test("amd64_linux")))[0].browser_download_url')
RUN mkdir /tmp/rcon
RUN tar -xf /tmp/rcon.tar.gz -C /tmp/rcon --strip-components=1
RUN install -m 755 /tmp/rcon/rcon /usr/local/bin/rcon-cli
RUN install -m 644 /tmp/rcon/rcon.yaml /etc/rcon.yaml
COPY --chmod=755 rcon /usr/local/bin/rcon
RUN rm -r /tmp/rcon.tar.gz /tmp/rcon

RUN mkdir /data
WORKDIR /data
RUN curl -fsSL -o "/tmp/pack.zip" "https://www.curseforge.com/api/v1/mods/681792/files/4496671/download"
RUN unzip -q /tmp/pack.zip
RUN rm /tmp/pack.zip

RUN curl -fsSL -o "server.jar" "https://meta.fabricmc.net/v2/versions/loader/1.18.2/0.14.22/0.11.2/server/jar"


RUN mkdir init
COPY --chmod=755 entrypoint.sh /entrypoint.sh

VOLUME [ "/data/world", "/data/backups" ]
EXPOSE 25565/tcp

ENTRYPOINT [ "/entrypoint.sh" ]
