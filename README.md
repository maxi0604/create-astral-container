# Introduction and Automatic Setup
Do you want to run a server for [Create: Astral](https://www.curseforge.com/minecraft/modpacks/create-astral) without the hassle of setting up Java and Fabric?
This repository allow you to run a server for the Create: Astral Minecraft® modpack using a container engine like [`podman`](https://podman.io/) or [`docker`](https://www.docker.com/).
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
to get access to the RCON interface to the last server you started where you can run admin commands. (`RCON_PASSWORD` must be set for this. The `-l` flag to operate on the last container is only supported by podman. Enter the container name for `docker` or if you have interacted with another container in the meantime.)

# Configuration
## server.properties
The container generates server.properties from your configuration as well as some defaults when started. To configure the server
- Enter only the desired configuration options into `server.properties`, for example:
```
# Example configuration, see https://server.properties or Minecraft Wiki for available options.
gamemode=creative
enable-command-block=true
```
Note that configuration changes you make overwrite configuration changes made by the image.
For example, if you include `rcon.password` in your server.properties instead of using the
environment variable, the RCON command above will fail due to the password not being equal
to the environment variable.

## ops.json, banned-players.json, banned-ips.json
These files are mounted as-is into the image. This means that this data is stored in the folder where
you run your compose command. The required templates for these files are included.

If you want to modify other files like those in the `config` folder, consider adding the
`/data/config` folder as a volume similar to how the files above are set up.

#  Manual Setup
The server can be set up without using a program like `podman-compose` or `docker-compose`.

Simply run (The commands should be mostly equivalent for `docker`)
```bash
podman volume create astral-world
podman volume create astral-backup
podman run -d -e EULA=TRUE \
  -e RCON_PASSWORD=hunter2 \
  -p 25565:25565 \
  -v ./ops.json:/data/ops.json:z \
  -v ./banned-players.json:/data/banned-players.json:z \
  -v ./banned-ips.json:/data/banned-ips.json:z \
  -v astral-world:/data/world:z \
  -v astral-backup:/data/backup:z \
  ghcr.io/maxi0604/create-astral:v2.1
```
to get started. This will run a Create: Astral server on port 25565 (the default) which stores the game world in a named volume.

# Maintenance
See the documentation for your preferred container engine for comprehensive guidance. Some hints:
- You can set up automatic restart using `restart: always` in `compose.yml` or the `--restart=always` flag when not using compose.
- Use `podman/docker logs [-f] <container name>` to inspect server logs. Adding `-f/--follow` causes log output to be displayed continously.
- Look into backing up the `world` volume.

# Contributing
Feel free to send a merge request for any improvements you'd like.

# License
I do not claim ownership of or affiliation with Minecraft®, Create: Astral or FabricMC.

This software package does not redistribute the Minecraft® server by itself, the server software is downloaded
when the container is initialized. The Create: Astral modpack is redistributed with preliminary permission from a developer.
To use this software you must agree to the [Minecraft EULA](https://www.minecraft.net/en-us/eula) by setting the environment variable `EULA=true`.
The files in this repository, where legally permissible, are licensed to you under the MIT license.
