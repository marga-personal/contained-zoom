# contained-zoom
A docker file and wrapper to run zoom inside a container.

## Pre-requisites

Requires a locally installed docker command (on a Debian based distro: `apt
install docker.io`).

Also, your user needs to be allowed to access docker resources. You might need
to add your user to the `docker` group (`sudo adduser <your user> docker;
newgrp docker` if you're on a Debian based distro).

## Generating the container

```
git clone https://github.com/margamanterola/contained-zoom
cd contained-zoom/
docker build -t zoom .
```

## Running the container

The `run-zoom.sh` wrapper can be used to invoke the command with the right
parameters. It will automatically give access to the audio and video of the
computer where it's running.

The container can be run with `PARANOID_MODE` on or off. When on, the
application won't write anything to disk. When off, the `.config/zoomus.conf`
file and the `.zoom` directory will be persisted to disk (not in their normal
paths, but in `.local/contained-zoom`).

### Associating the executable in Firefox

You can associate the `run-zoom.sh` script with the `zoommtg` Content Type in
Firefox to have the application open automatically from the
browser.

### Associating the executable in Chrome

In Chrome, Zoom triggers an `xdg-open` call, so you need to set up the
application association.  You can do this following these commands:

```
mkdir -p ~/.local/contained-zoom/
cp run-zoom.sh ~/.local/contained-zoom/
sed "s,~,$HOME,g" contained-zoom.desktop > $HOME/.local/share/applications/contained-zoom.desktop
cat mimeapps.list >> ~/.local/share/applications/mimeapps.list
```

