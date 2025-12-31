# bds.home.arpa

![CI](https://github.com/bdossantos/bds.home.arpa/workflows/CI/badge.svg?branch=master)

🏡 The source code and issue tracker of my house (powered by [@home-assistant](https://www.home-assistant.io/))

## ✨ Recent Updates

### Modern UI/UX Improvements

- **🎨 Modern Lovelace Dashboard**: Upgraded from legacy groups to modern card-based interface
- **🎭 Custom Themes**: Added light and dark theme variants with consistent Material Design
- **📱 Mobile Optimized**: Responsive layouts for all screen sizes
- **🏠 Room-Based Navigation**: Intuitive organization by living spaces
- **⚡ Quick Actions**: One-touch access to common scenes and controls
- **📊 Enhanced Monitoring**: Better visualization of sensors and system status

See the [UI Improvements Documentation](docs/UI_IMPROVEMENTS.md) for detailed information.

## Installation

```
git clone https://github.com/bdossantos/bds.home.arpa ~/Code/bds.home.arpa
~/Code/bds.home.arpa/scripts/deploy
```

## Hardware and network devices

- 1 \* APC BE700G-FR Onduleur BACK-UPS ES 700VA / 405 W
- 1 \* TP-Link Deco BE85
- 1 \* Module mini-GBiC SFP Multimode-Monomode/0.55-10km
- 1 \* Netgate 4100 MAX
- 1 \* Netgear GS308P-100PES Switch Gigabit Ethernet 8 Ports with 4 Ports PoE
- 1 \* Netgear EAX15
- 1 \* Synology DiskStation DS720+
- 1 \* TP-Link MC220L RJ45 Gigabit Converter

## Network

```
# $ ipcalc 10.92.64.0/22
# Address:   10.92.64.0           00001010.01011100.010000 00.00000000
# Netmask:   255.255.252.0 = 22   11111111.11111111.111111 00.00000000
# Wildcard:  0.0.3.255            00000000.00000000.000000 11.11111111
# =>
# Network:   10.92.64.0/22        00001010.01011100.010000 00.00000000
# HostMin:   10.92.64.1           00001010.01011100.010000 00.00000001
# HostMax:   10.92.67.254         00001010.01011100.010000 11.11111110
# Broadcast: 10.92.67.255         00001010.01011100.010000 11.11111111
# Hosts/Net: 1022                  Class A, Private Internet

10.92.64.0/22 bds.home.arpa
  10.92.64.0/24 infrastructure
    10.92.64.1 router.bds.home.arpa
    10.92.64.2 wifi.bds.home.arpa
    10.92.64.3 nas.bds.home.arpa
    10.92.64.5 wifi-ext.bds.home.arpa
    10.92.64.6 wifi-ext.bds.home.arpa
    10.92.64.7 wifi-ext.bds.home.arpa
  10.92.65.0/24 humans
    10.92.65.1 troubleshootinator.bds.home.arpa
    10.92.65.2 smartphone.bds.home.arpa
  10.92.66.0/24 IOT
    10.92.66.1 hue.bds.home.arpa
    10.92.66.2 phantomii-livingroom.bds.home.arpa
    10.92.66.4 smartplug-kitchen.bds.home.arpa
    10.92.66.5 hot-water-cylinder.bds.home.arpa
    10.92.66.6 nest-protect.bds.home.arpa
    10.92.66.7 tv.bds.home.arpa
    10.92.66.8 dyson-pure-hot-cool01.bds.home.arpa
    10.92.66.9 apple-tv.bds.home.arpa
  10.92.67.0/24 Guest ?
```

## Replace your Livebox 4 by a Pfsense Router

### Internet

- Add VLAN 832 on WAN interface: go to Interfaces -> Assignements -> VLANs
  - Parent Interface: your WAN interface
  - VLAN Tag: 832
  - VLAN Priority: 0
  - Description: "Orange Internet"
- Edit WAN interface and setup the DHCP:
  - IPv4 Configuration Type: DHCP
  - DHCP client Configuration:
    - Send options: `dhcp-class-identifier "sagem",user-class "+FSVDSL_livebox.Internet.softathome.Livebox3",option-90 $thescriptoutput`
    - Request options: `subnet-mask,broadcast-address,dhcp-lease-time,dhcp-renewal-time,dhcp-rebinding-time,domain-search,routers,domain-name-servers,option-90`
  - DHCP6 client Configuration:
    - DHCPv6 Prefix Delegation size: none
    - Send options: `ia-pd 0, raw-option 15 00:2b:46:53:56:44:53:4c:5f:6c:69:76:65:62:6f:78:2e:49:6e:74:65:72:6e:65:74:2e:73:6f:66:74:61:74:68:6f:6d:65:2e:6c:69:76:65:62:6f:78:33,raw-option 16 00:00:04:0e:00:05:73:61:67:65:6d,raw-option 6 00:0b:00:11:00:17:00:18,raw-option 11 $thescriptoutput`
    - Prefix interface statement: 0
    - sla-len: 8
    - Prefix Interface: LAN
- Add IPV6 Gateway

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

## Flash Netgate

```
login admin
sudo diskutil unmountDisk /dev/rdisk4
sudo dd if=/path/to/pfSense-plus-memstick-serial-23.05.1-RELEASE-amd64.img of=/dev/rdisk4 bs=4m status=progress
sudo diskutil eject /dev/rdisk4
```
