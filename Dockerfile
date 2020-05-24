FROM debian:buster

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y curl sudo && \
    curl -L https://zoom.us/client/latest/zoom_amd64.deb > /tmp/zoom.deb && \
    apt-get install -y --no-install-recommends /tmp/zoom.deb && \
    apt-get install -y --no-install-recommends libnss3 pulseaudio-utils libasound2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN adduser zoomuser --disabled-password --gecos "Zoom User" && \
    adduser zoomuser video

USER zoomuser
ENV HOME /home/zoomuser
ENV PULSE_SERVER /run/pulse/native

RUN mkdir -p /home/zoomuser/.zoom && \
    mkdir -p /home/zoomuser/.config && \
    touch /home/zoomuser/.config/zoomus.conf

CMD /usr/bin/zoom
