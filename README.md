# bds.home

[![Build Status](https://travis-ci.org/bdossantos/bds.home.svg?branch=feat%2Fhome-assistant)](https://travis-ci.org/bdossantos/bds.home)

🏡 My home source code ([@home-assistant](https://www.home-assistant.io/)) and issue tracker

## Installation

```
git clone https://github.com/bdossantos/bds.home ~/Code/bds.home
~/Code/bds.home/scripts/deploy
```

## Hardware and devices

* 1 * APC BE700G-FR Onduleur BACK-UPS ES 700VA / 405 W
* 1 * Aeon Labs - Z-Wave Plus Z-Stick GEN5
* 1 * Google Wifi
* 1 * Module mini-GBiC SFP Multimode-Monomode/0.55-10km
* 1 * Nest Protect 2
* 1 * Netatmo weather station
* 1 * Netgate SG-3100
* 1 * Netgear GS308P-100PES Switch Gigabit Ethernet 8 Ports with 4 Ports PoE
* 5 * Philips Hue Go
* 1 * Phillips Hue hub
* 1 * Plugable Technologies USB-BT4LE Bluetooth
* 1 * Raspberry Pi 3
* 1 * Synology DiskStation DS716+ II
* 1 * TP-Link HS100
* 1 * TP-Link MC220L RJ45 Gigabit Converter
* 2 * Fibaro Door / Window Sensor
* 6 * Fibaro Motion Sensor
* 2 * Philips Hue Motion Sensor
* 2 * Sonos PLAY:3
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
