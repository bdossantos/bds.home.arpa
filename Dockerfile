FROM python:3.13-trixie as build

ENV \
  DEBIAN_FRONTEND=noninteractive \
  PATH=$PATH:/app/bin \
  PYTHONUSERBASE=/app \
  VERSION=2025.7.4

COPY homeassistant /config
COPY homeassistant/secrets.yaml.dist /config/secrets.yaml

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -eux \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential=12.12 \
    cmake=3.31.6-2 \
    libavcodec-dev=7:7.1.3-0+deb13u1 \
    libavdevice-dev=7:7.1.3-0+deb13u1 \
    libavfilter-dev=7:7.1.3-0+deb13u1 \
    libavformat-dev=7:7.1.3-0+deb13u1 \
    libavutil-dev=7:7.1.3-0+deb13u1 \
    libbluetooth-dev=5.82-1.1 \
    libcurl4-openssl-dev=8.14.1-2+deb13u2 \
    libglib2.0-dev=2.84.4-3~deb13u2 \
    libgmp-dev=2:6.3.0+dfsg-3 \
    libmpc-dev=1.3.1-1+b3 \
    libmpfr-dev=4.2.2-1 \
    libswresample-dev=7:7.1.3-0+deb13u1 \
    libswscale-dev=7:7.1.3-0+deb13u1 \
    libturbojpeg0=1:2.1.5-4 \
    libudev-dev=257.9-1~deb13u1 \
    libuv1-dev=1.50.0-2 \
    libxrandr-dev=2:1.5.4-1+b3 \
    sqlite3=3.46.1-7 \
    swig=4.3.0-1 \
    zlib1g-dev=1:1.3.dfsg+really1.3.1-1+b1 \
  && pip install \
    --no-cache-dir \
    --prefix="${PYTHONUSERBASE}" \
      aiodiscover==2.1.0 \
      cython==0.29.35 \
      fnvhash==0.1.0 \
      google-api-core==2.11.0 \
      google-auth==2.19.1 \
      google-cloud==0.34.0 \
      grpcio==1.64.0 \
      homeassistant=="${VERSION}" \
      numpy==1.26.4 \
      pillow==11.0.0 \
      pip==23.1.2 \
      PyTurboJPEG==1.7.7 \
      psycopg2-binary==2.9.9 \
      pyspeex-noise==1.0.2 \
      webrtcvad==2.0.10 \
      wheel==0.40.0 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

FROM python:3.13-slim-trixie

ARG BUILD_DATE
ARG VCS_REF

ENV \
  DEBIAN_FRONTEND=noninteractive \
  LD_LIBRARY_PATH="/app/lib:/usr/lib64:$LD_LIBRARY_PATH" \
  PATH=$PATH:/app/bin \
  PYTHONUSERBASE=/app \
  TZ=Europe/Paris

LABEL org.label-schema.build-date="$BUILD_DATE" \
  org.label-schema.name="home-assistant" \
  org.label-schema.schema-version="1.0" \
  org.label-schema.url="https://github.com/bdossantos/bds.home" \
  org.label-schema.usage="https://github.com/bdossantos/bds.home" \
  org.label-schema.vcs-ref="$VCS_REF" \
  org.label-schema.vcs-url="https://github.com/bdossantos/bds.home" \
  org.label-schema.vendor="home-assistant" \
  org.label-schema.version="$VERSION" \
  org.opencontainers.image.created="$BUILD_DATE" \
  org.opencontainers.image.documentation="https://github.com/bdossantos/bds.home" \
  org.opencontainers.image.revision="$VCS_REF" \
  org.opencontainers.image.source="https://github.com/bdossantos/bds.home" \
  org.opencontainers.image.title="home-assistant" \
  org.opencontainers.image.url="https://github.com/bdossantos/bds.home" \
  org.opencontainers.image.vendor="home-assistant" \
  org.opencontainers.image.version="$VERSION"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -eux \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    bluetooth=5.82-1.1 \
    bluez=5.82-1.1 \
    ca-certificates=20250419 \
    ffmpeg=7:7.1.3-0+deb13u1 \
    iperf3=3.18-2+deb13u2 \
    iputils-ping=3:20240905-3 \
    libbluetooth3=5.82-1.1 \
    libmpc-dev=1.3.1-1+b3 \
    libturbojpeg0=1:2.1.5-4 \
    net-tools=2.10-1.3 \
    nmap=7.95+dfsg-3 \
    nut-client=2.8.1-5 \
    sqlite3=3.46.1-7 \
    zlib1g=1:1.3.dfsg+really1.3.1-1+b1 \
  && apt-get autoremove -y \
  && apt-get clean \
  && apt-get autoclean \
  && rm -rf /var/lib/apt/lists/*

COPY --from=build "$PYTHONUSERBASE" "$PYTHONUSERBASE"

EXPOSE 8123/tcp
EXPOSE 8300/tcp
EXPOSE 51827/tcp

CMD ["python", "-m", "homeassistant", "--config", "/config"]
