#!/bin/bash

# When paranoid mode is on, nothing is stored locally
# Zoom still has access to audio and video, but no locally stored data.
# When paranoid mode is off, zoom can store it's local config on disk
PARANOID_MODE=off

CONTAINER_NAME=contained-zoom

LOCAL_VOLS=""
if [[ ${PARANOID_MODE} == "off" ]]; then 
    LOCAL_DATA=~/.local/${CONTAINER_NAME}
    mkdir -p ${LOCAL_DATA}/.config
    mkdir -p ${LOCAL_DATA}/.zoom
    touch ${LOCAL_DATA}/.config/zoomus.conf

    LOCAL_VOLS=" \
	-v ${LOCAL_DATA}/.config/zoomus.conf:/home/zoomuser/.config/zoomus.conf \
	-v ${LOCAL_DATA}/.zoom:/home/zoomuser/.zoom \
    "
fi

if docker container inspect ${CONTAINER_NAME} 2>/dev/null >/dev/null; then
    docker container exec ${CONTAINER_NAME} zoom "$@"
else
    docker run --rm \
	--cap-add SYS_ADMIN \
	--net=host \
	--name ${CONTAINER_NAME} \
	-e DISPLAY=${DISPLAY} \
	--device /dev/video0:/dev/video0 \
	--device /dev/dri/card0:/dev/dri/card0 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /run/user/`id -u`/pulse:/run/pulse \
    ${LOCAL_VOLS} \
	zoom:latest \
	zoom "$@"
fi
