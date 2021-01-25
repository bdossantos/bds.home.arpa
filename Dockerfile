FROM python:3.9-buster as build

ENV \
  DEBIAN_FRONTEND=noninteractive \
  PATH=$PATH:/app/bin \
  PYTHONUSERBASE=/app \
  VERSION=2021.1.4

COPY homeassistant /config
COPY homeassistant/secrets.yaml.dist /config/secrets.yaml

RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential=12.6 \
    cmake=3.13.4-1 \
    libavcodec-dev=7:4.1.6-1~deb10u1 \
    libavdevice-dev=7:4.1.6-1~deb10u1 \
    libavfilter-dev=7:4.1.6-1~deb10u1 \
    libavformat-dev=7:4.1.6-1~deb10u1 \
    libavutil-dev=7:4.1.6-1~deb10u1 \
    libbluetooth-dev=5.50-1.2~deb10u1 \
    libcurl4-openssl-dev=7.64.0-4+deb10u1 \
    libglib2.0-dev=2.58.3-2+deb10u2 \
    libgmp-dev=2:6.1.2+dfsg-4 \
    libmpc-dev=1.1.0-1 \
    libmpfr-dev=4.0.2-1 \
    libpq5=11.9-0+deb10u1 \
    libswresample-dev=7:4.1.6-1~deb10u1 \
    libswscale-dev=7:4.1.6-1~deb10u1 \
    libudev-dev=241-7~deb10u5 \
    libuv1-dev=1.24.1-1 \
    libxrandr-dev=2:1.5.1-1 \
    swig=3.0.12-2 \
    zlib1g-dev=1:1.2.11.dfsg-1 \
  && python -m pip install --upgrade pip \
  && pip install \
    --no-cache-dir \
    --prefix="${PYTHONUSERBASE}" \
      cchardet \
      cython \
      google-auth==1.24.0 \
      grpcio-tools==1.35.0 \
      homeassistant=="${VERSION}" \
      pillow==7.2.0 \
      psycopg2-binary \
      pybluez \
  && python -m homeassistant --config /config --script check_config \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

FROM python:3.9-slim-buster

ENV \
  DEBIAN_FRONTEND=noninteractive \
  LD_LIBRARY_PATH="/app/lib:/usr/lib64:$LD_LIBRARY_PATH" \
  PATH=$PATH:/app/bin \
  PYTHONUSERBASE=/app \
  TZ=Europe/Paris

RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates=20200601~deb10u1 \
    nmap=7.70+dfsg1-6+deb10u1 \
    net-tools=1.60+git20180626.aebd88e-1 \
    bluetooth=5.50-1.2~deb10u1 \
    ffmpeg=7:4.1.6-1~deb10u1 \
    iperf3=3.6-2 \
    iputils-ping=3:20180629-2+deb10u1 \
    libbluetooth3=5.50-1.2~deb10u1 \
    libpq5=11.9-0+deb10u1 \
    nut-client=2.7.4-8 \
    zlib1g=1:1.2.11.dfsg-1 \
  && apt-get autoremove -y \
  && apt-get clean \
  && apt-get autoclean \
  && rm -rf /var/lib/apt/lists/*

COPY --from=build "$PYTHONUSERBASE" "$PYTHONUSERBASE"

EXPOSE 8123/tcp
EXPOSE 8300/tcp
EXPOSE 51827/tcp

CMD ["python", "-m", "homeassistant", "--config", "/config"]
