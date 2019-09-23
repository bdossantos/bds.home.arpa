FROM python:3.7-stretch as build

ENV \
  DEBIAN_FRONTEND=noninteractive \
  PATH=$PATH:/app/bin \
  PYTHONUSERBASE=/app \
  VERSION=0.99.2

ADD "https://raw.githubusercontent.com/home-assistant/home-assistant/${VERSION}/requirements_all.txt" "$PYTHONUSERBASE/requirements_all.txt"

RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential=12.3 \
    cmake=3.7.2-1 \
    libavcodec-dev=7:3.2.14-1~deb9u1 \
    libavdevice-dev=7:3.2.14-1~deb9u1 \
    libavfilter-dev=7:3.2.14-1~deb9u1 \
    libavformat-dev=7:3.2.14-1~deb9u1 \
    libavutil-dev=7:3.2.14-1~deb9u1 \
    libbluetooth-dev=5.43-2+deb9u1 \
    libcurl4-openssl-dev=7.52.1-5+deb9u9 \
    libglib2.0-dev=2.50.3-2+deb9u1 \
    libgmp-dev=2:6.1.2+dfsg-1 \
    libmpc-dev=1.0.3-1+b2 \
    libmpfr-dev=3.1.5-1 \
    libswresample-dev=7:3.2.14-1~deb9u1 \
    libswscale-dev=7:3.2.14-1~deb9u1 \
    libudev-dev=232-25+deb9u12 \
    libxrandr-dev=2:1.5.1-1 \
    swig=3.0.10-1.1 \
  && pip3 install \
    --no-cache-dir \
    --prefix="${PYTHONUSERBASE}" \
    -r "$PYTHONUSERBASE/requirements_all.txt" \
  && pip3 install \
    --no-cache-dir \
    --prefix="${PYTHONUSERBASE}" \
      mysqlclient \
      psycopg2 \
      uvloop==0.12.2 \
      cchardet \
      cython \
      tensorflow \
      pybluez==0.22 \
      homeassistant=="${VERSION}" \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

FROM python:3.7-slim-stretch

ENV \
  DEBIAN_FRONTEND=noninteractive \
  PATH=$PATH:/app/bin \
  PYTHONUSERBASE=/app \
  TZ=Europe/Paris

RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    nmap=7.40-1 \
    net-tools=1.60+git20161116.90da8a0-1 \
    bluetooth=5.43-2+deb9u1 \
    ffmpeg=7:3.2.14-1~deb9u1 \
    iperf3=3.1.3-1 \
    nut-client=2.7.4-5 \
  && apt-get autoremove -y \
  && apt-get clean \
  && apt-get autoclean \
  && rm -rf /var/lib/apt/lists/*

COPY --from=build "$PYTHONUSERBASE" "$PYTHONUSERBASE"

USER nobody

EXPOSE 8123
EXPOSE 8300
EXPOSE 51827

CMD ["python", "-m", "homeassistant", "--config", "/config"]
