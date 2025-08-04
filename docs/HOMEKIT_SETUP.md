# HomeKit Integration Documentation

## Overview

This document describes the HomeKit integration configuration for the BDS Home Assistant setup, providing seamless integration with iOS devices and the Apple ecosystem.

## HomeKit Bridge Configuration

### Network Settings
- **Bridge Name**: BDS Home Assistant
- **IP Address**: 10.92.64.3 (NAS IP)
- **Port**: 21063 (Custom port to avoid conflicts)
- **Auto Start**: Enabled for automatic startup

### Security Features
- **Safe Mode**: Enabled for better reliability and error recovery
- **Automatic Discovery**: mDNS broadcasting for iOS device discovery
- **Secure Pairing**: Uses Apple's HomeKit pairing protocol

## Exposed Entities

### Lights
- **Bedroom Lights**: 3 individual lights (Main + 2 Side lights)
- **Hallway Light**: Motion-activated entrance lighting
- **Kitchen Strip Light**: Under-cabinet LED strip
- **Living Room Light**: Main living area lighting

All lights support:
- On/Off control
- Brightness adjustment
- Color temperature (warm/cool white)
- Smooth transitions

### Switches & Controls
- **Water Heater**: Smart control for hot water cylinder
- **Kitchen Smart Plug**: Power control for kitchen appliances
- **Guest Mode**: Toggle for guest-optimized automation
- **Vacation Mode**: Security mode for extended absences

### Sensors
- **Motion Sensors**: Hallway and Kitchen motion detection
- **Temperature Sensors**: Environmental monitoring
- **Light Sensors**: Automatic brightness adjustment based on ambient light

### Media
- **Living Room TV**: Power, volume, and playback controls
- **Security Camera**: Live video streaming with audio support

### People
- **Benjamin**: Presence tracking and automation triggers
- **Partner**: Presence tracking for home/away routines

## HomeKit Scenes

### Available Scenes
1. **Good Morning**: Gradual warm lighting for wake-up routine
2. **Good Night**: Dimmed warm lights with automatic turn-off
3. **Movie Time**: Cinema mode with dimmed ambient lighting
4. **Away Secure**: Security mode turning off all devices
5. **Arrive Home**: Welcome lighting based on time and ambient light
6. **Candle Mode**: Romantic low warm lighting
7. **Energy Save**: Eco-friendly mode turning off non-essentials

### Scene Features
- **Time-based Logic**: Different behavior based on time of day
- **Ambient Light Awareness**: Only activates lights when needed
- **Smooth Transitions**: Professional lighting transitions
- **iOS Notifications**: Status updates sent to all devices

## Automation Features

### Motion-Based Lighting
- **Smart Activation**: Only in low-light conditions
- **Zone-based**: Different behaviors for different rooms
- **Auto Turn-off**: 10-minute delay after motion stops
- **Vacation Mode Respect**: Disabled during vacation mode

### Mode-Based Automation
- **Guest Mode**: Optimized behavior for visitors
- **Vacation Mode**: Security-focused automation
- **Energy Saving**: Automatic efficiency improvements

### Integration Monitoring
- **Bridge Status**: Notifications when HomeKit bridge starts
- **Connection Health**: Monitoring for connectivity issues
- **Error Logging**: Enhanced debugging for troubleshooting

## iOS Device Setup

### Initial Pairing
1. Open Home app on iOS device
2. Tap "Add Accessory"
3. Scan QR code or enter setup code from Home Assistant
4. Follow on-screen instructions for pairing

### HomeKit Code
The HomeKit setup code can be found in:
- Home Assistant Configuration > Integrations > HomeKit
- Notifications panel after bridge startup

### Recommended iOS Setup
- **Favorites**: Add frequently used lights and scenes
- **Control Center**: Configure Home controls for quick access
- **Automation**: Create iOS shortcuts for complex scenes
- **Siri Integration**: Enable voice control for all devices

## Network Configuration

### Requirements
- **Local Network**: All devices must be on same network (10.92.64.0/22)
- **mDNS**: Multicast DNS enabled for device discovery
- **Firewall**: Port 21063 accessible from iOS devices
- **IP Reservation**: Static IP recommended for bridge stability

### Troubleshooting Network Issues
1. Check IP connectivity: `ping 10.92.64.3`
2. Verify port access: `telnet 10.92.64.3 21063`
3. Restart Home Assistant if bridge shows offline
4. Reset HomeKit integration if pairing fails

## Performance Optimization

### Camera Streaming
- **Video Codec**: Copy mode for minimal CPU usage
- **Resolution**: Up to 1920x1080 at 30fps
- **Audio Support**: Enabled with optimized mapping
- **Bandwidth**: Automatic quality adjustment

### Bridge Performance
- **Entity Limit**: Optimized selection of most useful entities
- **Update Frequency**: Balanced for responsiveness and efficiency
- **Memory Usage**: Monitored for stability

## Logging and Debugging

### Log Levels
- **HomeKit Component**: Info level for operational monitoring
- **Accessories**: Warning level for error tracking
- **HAP Protocol**: Warning level for connection issues

### Common Issues
1. **Pairing Failures**: Check network connectivity and restart bridge
2. **Device Offline**: Verify Home Assistant is running and accessible
3. **Slow Response**: Check network latency and Home Assistant performance
4. **Missing Entities**: Verify entity is included in HomeKit filter

### Debug Commands
```bash
# Check HomeKit status
ha core logs --filter homekit

# Restart HomeKit integration
ha core restart
```

## Security Considerations

### Access Control
- **Local Network Only**: Bridge not accessible from internet
- **Encrypted Communication**: All HomeKit traffic is encrypted
- **Device Authentication**: Only paired devices can control accessories

### Best Practices
- **Regular Updates**: Keep Home Assistant updated for security patches
- **Network Isolation**: Consider IoT VLAN for smart home devices
- **Access Monitoring**: Review HomeKit device list regularly

## Future Enhancements

### Planned Improvements
- **Energy Monitoring**: Power usage tracking for HomeKit
- **Weather Integration**: Outdoor condition-based automation
- **Advanced Scenes**: Seasonal and event-based lighting
- **Security Integration**: Door locks and alarm system

### Expansion Possibilities
- **Additional Cameras**: Multi-room security coverage
- **Climate Control**: HVAC integration via HomeKit
- **Outdoor Devices**: Garden and exterior lighting
- **Music Integration**: Multi-room audio control

## Support and Maintenance

### Regular Maintenance
- **Weekly**: Check bridge status and device connectivity
- **Monthly**: Review automation performance and adjust as needed
- **Quarterly**: Update Home Assistant and review security settings

### Getting Help
- **Documentation**: Home Assistant HomeKit component docs
- **Community**: Home Assistant community forums
- **Issues**: GitHub repository for bug reports and feature requests
