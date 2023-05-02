# Introduction and Automatic Setup
Do you want to run a server for Create: Astral without the hassle of setting up Java and Fabric.
This repository allow you to run a server for the Create: Astral Minecraft® modpack using a container engine like `podman` or `docker`.
Everything is bundled, just do some configuration and you're set.

To set up:
- Clone this repository
- Accept the Minecraft EULA by changing `EULA: "FALSE"` to `EULA: "TRUE"` in compose.yml
- Choose a secure password for RCON. (RCON is not exposed to the network by default)
- Run `podman-compose up -d`

The server should now be up and running.

Run 
```bash
podman exec -itl rcon
```
to get access to the RCON interface to the last server you started where you can run admin commands. (`RCON_PASSWORD` must be set for this.)

This image is still quite new and features might still be added (or worse, removed) from it.

#  Manual Setup
The server can be set up without using a layer like `podman-compose` or `docker-compose`.

Simply run (The commands should be mostly equivalent for `docker`)
```bash
podman volume create astral-world
podman run -d -e EULA=TRUE \
  -e RCON_PASSWORD=hunter2 \
  -p 25565:25565 \
  -v astral-world:/data/world \
  ghcr.io/maxi0604/create-astral:main
```
to get started. This will run a Create: Astral server on port 25565 (the default) which stores the game world in a named volume.

## Configuration
### server.properties
The container generates server.properties from your configuration as well as some defaults when started. To configure the server
- Create a file `server.properties` on your machine.
- Enter the desired configuration options into `server.properties`, for example:
```
# Example configuration, see https://server.properties or Minecraft Wiki for available options.
gamemode=creative
enable-command-block=true
```
- Mount your configuration into the container by adding `-v ./server.properties:/init/server.properties:z`
(You can name the file differently on the host machine but the mount point within the container must remain the same.)
- Note that changes you make in the file overwrite changes made by the container. For example, if you set `rcon.password` yourself,
you will not be able to connect to the RCON server with the command given above, even if you have set `RCON_PASSWORD`.

### ops.json and other Files
If you want the list of server OPs other files to be stored outside of the container, mount them as such, e. g. `-v ./ops.json:/data/ops.json:z`

# License
I do not claim ownership of or affiliation with Minecraft®, Create: Astral or FabricMC.
This software package does not redistribute the Minecraft® server by itself, the server software is downloaded
when the container is initialized. The Create: Astral modpack is redistributed with preliminary permission from a developer.
To use this software you must agree to the [Minecraft EULA](https://www.minecraft.net/en-us/eula) by setting the environment variable `EULA=true`.
The files in this repository, where legally permissible, are licensed to you under the MIT license.
