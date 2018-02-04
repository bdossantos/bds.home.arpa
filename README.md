# bds.home

[![Build Status](https://travis-ci.org/bdossantos/bds.home.svg?branch=feat%2Fhome-assistant)](https://travis-ci.org/bdossantos/bds.home)

My LAN Dnsmasq, dnscrypt-proxy, tor, Polipo, Home Assistant [...] configurations.

## Installation

```
git clone https://github.com/bdossantos/bds.home /opt/bds.home
cd /opt/bds.home
sudo make install
```

## Hardware and devices

* 1 * APC BE700G-FR Onduleur BACK-UPS ES 700VA / 405 W
* 1 * Google Wifi
* 1 * Nest Protect 2
* 1 * Netatmo weather station
* 1 * Netgate SG-1000
* 1 * Netgear GS308P-100PES Switch Gigabit Ethernet 8 Ports with 4 Ports PoE
* 1 * Philips Hue Go
* 2 * Philips Hue Motion Sensor
* 1 * Phillips Hue tap
* 1 * Phillips Hue hub
* 1 * Raspberry Pi 2
* 1 * Raspberry Pi 3
* 2 * Sonos PLAY:3
* 1 * Synology DiskStation DS716+ II
* 6 * Phillips Hue bulbs

## Replace your Livebox 4 by a Pfsense Router

### Internet

* Add VLAN 835 on WAN interface: go to Interfaces -> Assignements -> VLANs
  * Parent Interface: your WAN interface
  * VLAN Tag: 835
  * VLAN Priority: 0
  * Description:  "Orange Internet"
* Edit WAN interface and setup the PPPoE:
  * IPv4 Configuration Type: PPPoE
  * PPPoE Configuration:
    * Username: fti/xxxx
    * Password: secret
