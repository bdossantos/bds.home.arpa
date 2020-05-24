FROM python:3.8.3-buster as build

ENV \
  DEBIAN_FRONTEND=noninteractive \
  PATH=$PATH:/app/bin \
  PYTHONUSERBASE=/app \
  VERSION=0.110.2

ADD "https://raw.githubusercontent.com/home-assistant/home-assistant/${VERSION}/requirements_all.txt" "$PYTHONUSERBASE/requirements_all.txt"

RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential=12.6 \
    cmake=3.13.4-1 \
    libavcodec-dev=7:4.1.4-1~deb10u1 \
    libavdevice-dev=7:4.1.4-1~deb10u1 \
    libavfilter-dev=7:4.1.4-1~deb10u1 \
    libavformat-dev=7:4.1.4-1~deb10u1 \
    libavutil-dev=7:4.1.4-1~deb10u1 \
    libbluetooth-dev=5.50-1.2~deb10u1 \
    libcurl4-openssl-dev=7.64.0-4+deb10u1 \
    libglib2.0-dev=2.58.3-2+deb10u2 \
    libgmp-dev=2:6.1.2+dfsg-4 \
    libmpc-dev=1.1.0-1 \
    libmpfr-dev=4.0.2-1 \
    libpq5=11.7-0+deb10u1 \
    libswresample-dev=7:4.1.4-1~deb10u1 \
    libswscale-dev=7:4.1.4-1~deb10u1 \
    libudev-dev=241-7~deb10u4 \
    libxrandr-dev=2:1.5.1-1 \
    swig=3.0.12-2 \
  && pip3 install \
    --no-cache-dir \
    --prefix="${PYTHONUSERBASE}" \
    -r "$PYTHONUSERBASE/requirements_all.txt" \
  && pip3 install \
    --no-cache-dir \
    --prefix="${PYTHONUSERBASE}" \
      mysqlclient \
      psycopg2-binary \
      uvloop==0.12.2 \
      cchardet \
      cython \
      tensorflow \
      pybluez==0.22 \
      homeassistant=="${VERSION}" \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

FROM python:3.8.3-buster

ENV \
  DEBIAN_FRONTEND=noninteractive \
  LD_LIBRARY_PATH="/app/lib:/usr/lib64:$LD_LIBRARY_PATH" \
  PATH=$PATH:/app/bin \
  PYTHONUSERBASE=/app \
  TZ=Europe/Paris

RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates=20190110 \
    nmap=7.70+dfsg1-6 \
    net-tools=1.60+git20180626.aebd88e-1 \
    bluetooth=5.50-1.2~deb10u1 \
    ffmpeg=7:4.1.4-1~deb10u1 \
    iperf3=3.6-2 \
    iputils-ping=3:20180629-2+deb10u1 \
    libbluetooth3=5.50-1.2~deb10u1 \
    libpq5=11.7-0+deb10u1 \
    nut-client=2.7.4-8 \
  && apt-get autoremove -y \
  && apt-get clean \
  && apt-get autoclean \
  && rm -rf /var/lib/apt/lists/*

COPY --from=build "$PYTHONUSERBASE" "$PYTHONUSERBASE"

EXPOSE 8123
EXPOSE 8300
EXPOSE 51827

CMD ["python", "-m", "homeassistant", "--config", "/config"]
