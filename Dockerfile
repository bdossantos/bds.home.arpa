FROM homeassistant/home-assistant:0.84.1

ENV \
  DEBIAN_FRONTEND=noninteractive \
  TZ=Europe/Paris

RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    nut-client=2.7.4-5 \
  && apt-get autoremove -y \
  && apt-get clean \
  && apt-get autoclean \
  && rm -rf /var/lib/apt/lists/*
