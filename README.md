# Introduction
Run a server for the Create: Astral Minecraft® using a container engine like `podman` or `docker`.

Simply run 
```
podman volume create astral-world
podman run -e EULA=TRUE -e JVM_ARGS="-Xmx8192m" -p 25565:25565 -v astral-world:/world astral-contain:latest
```
to get started.


# License
I do not claim ownership of or affiliation with Minecraft®,  Create: Astral or FabricMC.
This software package does not redistribute the Minecraft® server by itself, the server software is downloaded
when the container is initialized. The Create: Astral modpack is redistributed with preliminary permission from a developer.
To use this software you must agree to the [Minecraft EULA](https://www.minecraft.net/en-us/eula) by setting the environment variable `EULA=true`.
The files in this repository, where legally permissible, are licensed to you under the MIT license.
