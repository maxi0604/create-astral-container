FROM eclipse-temurin:17-jre-jammy
RUN apt-get -qq update && apt-get -qq install -y unzip jq

RUN curl -fsSL -o "/tmp/pack.zip" "https://www.curseforge.com/api/v1/mods/681792/files/4496671/download"
RUN unzip -q /tmp/pack.zip
RUN rm /tmp/pack.zip

RUN curl -fsSL -o "server.jar" "https://meta.fabricmc.net/v2/versions/loader/1.18.2/0.14.19/0.11.2/server/jar"

RUN curl -fsSL -o "rcon.tar.gz" $(curl -s https://api.github.com/repos/gorcon/rcon-cli/releases/latest | jq -r '.assets | map(select(.name | test("amd64_linux")))[0].browser_download_url')
RUN mkdir ./rcon
RUN tar -xf rcon.tar.gz -C ./rcon --strip-components=1
RUN install -m 755 rcon/rcon /usr/local/bin/rcon-cli
RUN install -m 644 rcon/rcon.yaml /etc/rcon.yaml
COPY --chmod=755 rcon /usr/local/bin/rcon

COPY --chmod=755 entrypoint.sh /entrypoint.sh
RUN rm -r rcon.tar.gz rcon

VOLUME /world
EXPOSE 25565/tcp

ENTRYPOINT [ "/entrypoint.sh" ]
