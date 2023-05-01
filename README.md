# Introduction
Run a server for the Create: Astral Minecraft® modpack using a container engine like `podman` or `docker`.

Simply run (The commands should be mostly equivalent for `docker`)
```bash
podman volume create astral-world # By running the following command you agree to the Minecraft EULA.
podman run -d -e EULA=TRUE \
  -e RCON_PASSWORD=hunter2 \
  -p 25565:25565 \
  -v astral-world:/world \
  ghcr.io/maxi0604/create-astral:main
```
to get started. This will run a Create: Astral server on port 25565 (the default) which stores the game world in a named volume.

Run 
```bash
podman exec -itl rcon
```
to get access to the RCON interface to the last server you started where you can run admin commands. (`RCON_PASSWORD` must be set for this.)

This image is still quite new and features might still be added (or worse, removed) from it.

# License
I do not claim ownership of or affiliation with Minecraft®, Create: Astral or FabricMC.
This software package does not redistribute the Minecraft® server by itself, the server software is downloaded
when the container is initialized. The Create: Astral modpack is redistributed with preliminary permission from a developer.
To use this software you must agree to the [Minecraft EULA](https://www.minecraft.net/en-us/eula) by setting the environment variable `EULA=true`.
The files in this repository, where legally permissible, are licensed to you under the MIT license.
