# Build xrdp pulseaudio modules in builder container
# See https://github.com/neutrinolabs/pulseaudio-module-xrdp/wiki/README
ARG TAG=focal

FROM ubuntu:$TAG AS builder

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qqy \
    && apt-get install -qqy --no-install-recommends \
        sudo \
        build-essential \
        dpkg-dev \
        libpulse-dev \
        autoconf \
        libtool \
        git \
        debootstrap schroot lsb-release \
    && apt-get install -qqy --no-install-recommends --reinstall ca-certificates \
    && update-ca-certificates \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN git clone --depth 1 --branch v0.7 https://github.com/neutrinolabs/pulseaudio-module-xrdp.git \
    && cd /pulseaudio-module-xrdp \
    && sed -i 's/apt-get/DEBIAN_FRONTEND=noninteractive apt-get/' ./scripts/install_pulseaudio_sources_apt.sh || true  \
    && ./scripts/install_pulseaudio_sources_apt.sh -d "$(pwd)/pulseaudio.src" \
    && ./bootstrap  \
    && ./configure PULSE_DIR="$(pwd)/pulseaudio.src" \
    && make  \
    && make install 

# Build the final image
FROM ubuntu:$TAG

ARG USER_NAME=ubuntu \
    USER_UID=1000 \
    USER_GID=1000 \
    USER_PASSWORD=ubuntu 

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qqy \
    && apt-get install -qqy --no-install-recommends --no-install-suggests \
      sudo \
      pavucontrol \
      pulseaudio \
      xfce4 \
      xfce4-goodies \
      xubuntu-icon-theme \
      locales \
      dbus-x11 \
      x11-xserver-utils \
      xorgxrdp \
      xrdp \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*
ENV LANG=en_US.UTF-8

RUN sed -i -E 's/^; autospawn =.*/autospawn = yes/' /etc/pulse/client.conf \
    && [ -f /etc/pulse/client.conf.d/00-disable-autospawn.conf ] && sed -i -E 's/^(autospawn=.*)/# \1/' /etc/pulse/client.conf.d/00-disable-autospawn.conf || :

COPY --from=builder /usr/lib/pulse-*/modules/module-xrdp-sink.so /usr/lib/pulse-*/modules/module-xrdp-source.so /var/lib/xrdp-pulseaudio-installer/

# Create the group if it doesn't exist, and set the specified GID
RUN if ! getent group $USER_NAME >/dev/null; then \
        groupadd -g $USER_GID $USER_NAME; \
    fi

# Create the user if it doesn't exist, and set the specified UID and GID
RUN if ! id -u $USER_NAME >/dev/null 2>&1; then \
        useradd -m -u $USER_UID -g $USER_GID -s /bin/bash $USER_NAME; \ 
        usermod -aG sudo $USER_NAME; \
    fi

RUN echo "$USER_NAME:$USER_PASSWORD" | chpasswd

COPY --chmod=755 entrypoint.sh /usr/bin/entrypoint
EXPOSE 3389/tcp
ENTRYPOINT ["/usr/bin/entrypoint"]
