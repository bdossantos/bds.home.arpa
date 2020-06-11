# bds.home

[![Build Status](https://travis-ci.org/bdossantos/bds.home.svg?branch=feat%2Fhome-assistant)](https://travis-ci.org/bdossantos/bds.home)

🏡 The source code and issue tracker of my house (powered by [@home-assistant](https://www.home-assistant.io/))

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

* Add VLAN 832 on WAN interface: go to Interfaces -> Assignements -> VLANs
  * Parent Interface: your WAN interface
  * VLAN Tag: 832
  * VLAN Priority: 0
  * Description:  "Orange Internet"
* Edit WAN interface and setup the DHCP:
  * IPv4 Configuration Type: DHCP
  * DHCP Configuration:
    * Send options: `dhcp-class-identifier "sagem",user-class "+FSVDSL_livebox.Internet.softathome.Livebox3",option-90 $thescriptoutput`
    * Request options: `subnet-mask,broadcast-address,dhcp-lease-time,dhcp-renewal-time,dhcp-rebinding-time,domain-search,routers,domain-name-servers,option-90`

This helper script help you to generate `Send options` section:

```bash
#!/usr/bin/env bash

login='fti/*******'
pass='*********'

tohex() {
  for h in $(echo $1 | sed "s/\(.\)/\1 /g"); do
    printf %02x \'$h
  done
}

addsep() {
  echo $(echo $1 | sed "s/\(.\)\(.\)/:\1\2/g")
}

r=$(dd if=/dev/urandom bs=1k count=1 2>&1 | md5sum | cut -c1-16)
id=${r:0:1}
h=3C12$(tohex ${r})0313$(tohex ${id})$(echo -n ${id}${pass}${r} | md5sum | cut -c1-32)

echo 00:00:00:00:00:00:00:00:00:00:00:1A:09:00:00:05:58:01:03:41:01:0D$(addsep $(tohex ${login})${h})
```
