FROM python:3.12-bullseye as build

ENV \
  DEBIAN_FRONTEND=noninteractive \
  PATH=$PATH:/app/bin \
  PYTHONUSERBASE=/app \
  VERSION=2023.10.3

COPY homeassistant /config
COPY homeassistant/secrets.yaml.dist /config/secrets.yaml

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -eux \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential=12.9 \
    cmake=3.18.4-2+deb11u1 \
    libavcodec-dev=7:4.3.6-0+deb11u1 \
    libavdevice-dev=7:4.3.6-0+deb11u1 \
    libavfilter-dev=7:4.3.6-0+deb11u1 \
    libavformat-dev=7:4.3.6-0+deb11u1 \
    libavutil-dev=7:4.3.6-0+deb11u1 \
    libcurl4-openssl-dev=7.74.0-1.3+deb11u7 \
    libglib2.0-dev=2.66.8-1 \
    libgmp-dev=2:6.2.1+dfsg-1+deb11u1 \
    libmpc-dev=1.2.0-1 \
    libmpfr-dev=4.1.0-3 \
    libswresample-dev=7:4.3.6-0+deb11u1 \
    libswscale-dev=7:4.3.6-0+deb11u1 \
    libudev-dev=247.3-7+deb11u2 \
    libuv1-dev=1.40.0-2 \
    libxrandr-dev=2:1.5.1-1 \
    sqlite3=3.34.1-3 \
    swig=4.0.2-1 \
    zlib1g-dev=1:1.2.11.dfsg-2+deb11u2 \
  && pip install \
    --no-cache-dir \
    --prefix="${PYTHONUSERBASE}" \
      aiodiscover==1.4.16 \
      cython==0.29.35 \
      fnvhash==0.1.0 \
      google-api-core==2.11.0 \
      google-auth==2.19.1 \
      google-cloud==0.34.0 \
      grpcio==1.54.2 \
      homeassistant=="${VERSION}" \
      pillow==9.5.0 \
      pip==23.1.2 \
      psycopg2-binary==2.9.6 \
      sqlalchemy==2.0.15 \
      webrtcvad==2.0.10 \
      wheel==0.40.0 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

FROM python:3.12-slim-bullseye

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
    ca-certificates=20210119 \
    ffmpeg=7:4.3.6-0+deb11u1 \
    iperf3=3.9-1+deb11u1 \
    iputils-ping=3:20210202-1 \
    net-tools=1.60+git20181103.0eebece-1 \
    nmap=7.91+dfsg1+really7.80+dfsg1-2 \
    nut-client=2.7.4-13 \
    sqlite3=3.34.1-3 \
    zlib1g=1:1.2.11.dfsg-2+deb11u2 \
  && apt-get autoremove -y \
  && apt-get clean \
  && apt-get autoclean \
  && rm -rf /var/lib/apt/lists/*

COPY --from=build "$PYTHONUSERBASE" "$PYTHONUSERBASE"

EXPOSE 8123/tcp
EXPOSE 8300/tcp
EXPOSE 51827/tcp

CMD ["python", "-m", "homeassistant", "--config", "/config"]
