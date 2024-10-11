FROM eclipse-temurin:17-jre-jammy AS builder
RUN apt-get -qq update && apt-get -qq install -y unzip jq

# Set TARGETPLATFORM to be used for platform-specific downloads
ARG TARGETPLATFORM

# Download the correct rcon-cli binary based on the TARGETPLATFORM
RUN case "$TARGETPLATFORM" in \
    "linux/amd64") \
        echo "Detected amd64"; \
        curl -fsSL -o "/tmp/rcon.tar.gz" $(curl -s https://api.github.com/repos/itzg/rcon-cli/releases/latest | jq -r '.assets | map(select(.name | test("linux_amd64")))[0].browser_download_url'); \
        ;; \
    "linux/arm64") \
        echo "Detected arm64"; \
        curl -fsSL -o "/tmp/rcon.tar.gz" $(curl -s https://api.github.com/repos/itzg/rcon-cli/releases/latest | jq -r '.assets | map(select(.name | test("linux_arm64")))[0].browser_download_url'); \
        ;; \
    *) echo "Unsupported platform: $TARGETPLATFORM"; exit 1 ;; \
    esac

RUN mkdir /tmp/rcon
RUN tar -xf /tmp/rcon.tar.gz -C /tmp/rcon




WORKDIR /data
RUN curl -fsSL -o "/tmp/pack.zip" "https://www.curseforge.com/api/v1/mods/681792/files/5795941/download"
RUN curl -fsSL -o "/tmp/old.zip" "https://www.curseforge.com/api/v1/mods/681792/files/4496671/download"
RUN unzip -q /tmp/pack.zip -d /data
RUN unzip -q /tmp/old.zip -d /tmp/old/
RUN cp /tmp/old/mods/vinery-1.1.4.jar mods/
RUN cp /tmp/old/mods/Hephaestus-1.18.2-3.5.2.155.jar mods/
RUN curl -fsSL -o "server.jar" "https://meta.fabricmc.net/v2/versions/loader/1.18.2/0.16.3/0.11.1/server/jar"

FROM eclipse-temurin:17-jre-jammy
COPY --from=builder --chmod=755 /tmp/rcon/rcon-cli /usr/local/bin/rcon-cli
COPY --chmod=755 rcon /usr/local/bin/rcon
COPY --chmod=755 entrypoint.sh /entrypoint.sh

COPY --from=builder /data /data
WORKDIR /data

VOLUME [ "/data/world", "/data/backups" ]
EXPOSE 25565/tcp

ENTRYPOINT [ "/entrypoint.sh" ]
