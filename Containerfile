FROM eclipse-temurin:17-jre-jammy
RUN apt-get update && apt-get install unzip
WORKDIR /server
RUN curl -fsSL -o "/tmp/pack.zip" "https://www.curseforge.com/api/v1/mods/681792/files/4496671/download"
RUN unzip /tmp/pack.zip
RUN rm /tmp/pack.zip
RUN curl -fsSL -o "server.jar" "https://meta.fabricmc.net/v2/versions/loader/1.18.2/0.14.19/0.11.2/server/jar"
COPY --chmod=755 entrypoint.sh /entrypoint.sh
VOLUME /server/world
ENTRYPOINT [ "/entrypoint.sh" ]
EXPOSE 25565/tcp
