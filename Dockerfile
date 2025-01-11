FROM python:3.13-bookworm as build

ENV \
  DEBIAN_FRONTEND=noninteractive \
  PATH=$PATH:/app/bin \
  PYTHONUSERBASE=/app \
  VERSION=2025.1.2

COPY homeassistant /config
COPY homeassistant/secrets.yaml.dist /config/secrets.yaml

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -eux \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential=12.9 \
    cmake=3.25.1-1 \
    libavcodec-dev=7:5.1.6-0+deb12u1 \
    libavdevice-dev=7:5.1.6-0+deb12u1 \
    libavfilter-dev=7:5.1.6-0+deb12u1 \
    libavformat-dev=7:5.1.6-0+deb12u1 \
    libavutil-dev=7:5.1.6-0+deb12u1 \
    libbluetooth-dev=5.66-1+deb12u2 \
    libcurl4-openssl-dev=7.88.1-10+deb12u8 \
    libglib2.0-dev=2.74.6-2+deb12u5 \
    libgmp-dev=2:6.2.1+dfsg1-1.1 \
    libmpc-dev=1.3.1-1 \
    libmpfr-dev=4.2.0-1 \
    libswresample-dev=7:5.1.6-0+deb12u1 \
    libswscale-dev=7:5.1.6-0+deb12u1 \
    libturbojpeg0=1:2.1.5-2 \
    libudev-dev=252.33-1~deb12u1 \
    libuv1-dev=1.44.2-1+deb12u1 \
    libxrandr-dev=2:1.5.2-2+b1 \
    sqlite3=3.40.1-2+deb12u1 \
    swig=4.1.0-0.2 \
    zlib1g-dev=1:1.2.13.dfsg-1 \
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

FROM python:3.13-slim-bookworm

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
    bluetooth=5.66-1+deb12u2 \
    bluez=5.66-1+deb12u2 \
    ca-certificates=20230311 \
    ffmpeg=7:5.1.6-0+deb12u1 \
    iperf3=3.12-1+deb12u1 \
    iputils-ping=3:20221126-1+deb12u1 \
    libbluetooth3=5.66-1+deb12u2 \
    libmpc-dev=1.3.1-1 \
    libturbojpeg0=1:2.1.5-2 \
    net-tools=2.10-0.1 \
    nmap=7.93+dfsg1-1 \
    nut-client=2.8.0-7 \
    sqlite3=3.40.1-2+deb12u1 \
    zlib1g=1:1.2.13.dfsg-1 \
  && apt-get autoremove -y \
  && apt-get clean \
  && apt-get autoclean \
  && rm -rf /var/lib/apt/lists/*

COPY --from=build "$PYTHONUSERBASE" "$PYTHONUSERBASE"

EXPOSE 8123/tcp
EXPOSE 8300/tcp
EXPOSE 51827/tcp

CMD ["python", "-m", "homeassistant", "--config", "/config"]
