# Dyson Integration Setup

This directory contains the setup for the Dyson Pure Hot Cool integration in Home Assistant.

## Prerequisites

1. **libdyson Library**: Added to the Docker image dependencies in `Dockerfile`
2. **ha-dyson Custom Component**: Must be installed before starting Home Assistant

## Installation Steps

### 1. Install the Custom Component

Run the installation script to download and install the ha-dyson custom component:

```bash
./scripts/install-dyson-integration.sh
```

This script will:
- Download the latest release of ha-dyson from GitHub
- Extract the custom component to `homeassistant/custom_components/dyson/`
- Provide setup instructions

### 2. Configure Secrets

Add your Dyson account credentials to `homeassistant/secrets.yaml`:

```yaml
dyson_username: your_dyson_email@example.com
dyson_password: your_dyson_password
```

### 3. Build and Start Home Assistant

```bash
make build
make up
```

### 4. Configure Integration in Home Assistant

1. Navigate to **Settings** > **Devices & Services**
2. Click **Add Integration**
3. Search for **Dyson**
4. Follow the setup wizard:
   - Option A: Use your MyDyson account (recommended)
   - Option B: Use device Wi-Fi information from the sticker

## Integration Features

### Fan Control (`homeassistant/fan/dyson.yaml`)
- Speed adjustment (1-10)
- Oscillation control
- Power on/off
- Timer functions

### Climate Control (`homeassistant/climate/dyson.yaml`)
- Heating mode
- Temperature control
- Heat mode on/off

### Sensors (Auto-discovered)
- PM2.5 air quality
- PM10 air quality
- VOC index
- NO2 index
- Temperature
- Humidity
- Filter life

### HomeKit Integration
- Fan controls available in Apple Home app
- Climate controls as thermostat
- Temperature sensors for automation

## Device Information

- **Device**: Dyson Pure Hot Cool
- **Hostname**: dyson-pure-hot-cool01.bds.home.arpa
- **IP Address**: 10.92.66.8
- **Supported Models**: HP07, HP09, TP07, TP09, and others (see ha-dyson documentation)

## Troubleshooting

### Connection Issues
1. **Power cycle the device**: Unplug for 10 seconds and plug back in
2. **Check network connectivity**: Ensure device is on the same network
3. **Verify credentials**: Check MyDyson account email/password
4. **Check MQTT**: Device runs an MQTT broker with connection limits

### Integration Not Found
1. Ensure the custom component is installed: `ls homeassistant/custom_components/dyson/`
2. Restart Home Assistant after installing the component
3. Check Home Assistant logs for errors

### Platform Configuration Issues
The configuration files (`fan/dyson.yaml` and `climate/dyson.yaml`) use the `dyson` platform which is provided by the custom component. If you see "Unknown platform" errors, ensure:
1. The custom component is properly installed
2. Home Assistant has been restarted
3. The libdyson dependency is available

## References

- [ha-dyson GitHub Repository](https://github.com/libdyson-wg/ha-dyson)
- [libdyson Python Library](https://github.com/libdyson-wg/libdyson)
- [Home Assistant Custom Components Documentation](https://developers.home-assistant.io/docs/creating_integration_file_structure/)