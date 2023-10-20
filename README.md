# DD-WRT Configuration

My home DD-WRT configuration for privacy, security, and performance. Documenting mostly so I can remember my preferred settings whenever I update/reset the router.

All settings are kept as default unless otherwise noted below. Sensitive information is annotated with "{REDACTED}".

## Current Router

- [Netgear R7800](https://www.netgear.com/home/products/networking/wifi-routers/R7800.aspx)
- [DD-WRT Netgear R7800 Wiki](https://wiki.dd-wrt.com/wiki/index.php/Netgear_R7800)

## Current DD-WRT Build

- [v3.0-r53562 (10/03/23)](https://forum.dd-wrt.com/phpBB2/viewtopic.php?t=335156)

## 3rd-Party Services

- [ProtonVPN](https://protonvpn.com)
- [NextDNS](https://nextdns.io)

## Configuration

### Setup

#### Basic Setup

##### Network Setup

###### NTP Client Settings

- Time Zone: {REDACTED}

### Wireless

#### Basic Settings

##### Physical Interface wlan0 [5 GHz/802.11ac]

- Service Set Identifier (SSID): {REDACTED}
- Network Mode: `AC / N Mixed`[^2]
- Channel Width: `VHT80`[^3]
- Channel: {least congested, maybe prefer 149-161, don't use Auto}[^3]
- Extension Channel: {paired with Channel leads to least congested}[^3]
- Advanced Settings: `✓`
- Firmware Type: `VANILLA`[^1]
- Airtime Fairness: `Disable`[^1]

##### Virtual Interfaces wlan0.1

- Service Set Identifier (SSID): {REDACTED}
- Advanced Settings: `✓`
- AP Isolation: `Enable`

##### Physical Interface wlan1 [2.4 GHz]

- Service Set Identifier (SSID): {REDACTED}
- Network Mode: `N / G Mixed`[^3]
- Channel: {least congested, don't use Auto}[^3]
- TurboQAM (QAM256): `Enable`[^3]
- Advanced Settings: `✓`
- Firmware Type: `VANILLA`[^1]
- Airtime Fairness: `Disable`[^1]

##### Virtual Interfaces wlan1.1

- Service Set Identifier (SSID): {REDACTED}
- Advanced Settings: `✓`
- AP Isolation: `Enable`

#### Wireless Security

##### Physical Interface wlan0

- WPA Shared Key: {REDACTED}

##### Virtual Interfaces wlan0.1

- Security Mode: `WPA`
- Network Authentication: `WPA2 Personal`
- WPA Shared Key: {REDACTED}

##### Physical Interface wlan1

- WPA Shared Key: {REDACTED}

##### Virtual Interfaces wlan1.1

- Security Mode: `WPA`
- Network Authentication: `WPA2 Personal`
- WPA Shared Key: {REDACTED}

[^1]: [DD-WRT Netgear R7800 Install Guide](https://forum.dd-wrt.com/phpBB2/viewtopic.php?t=320614)
[^2]: [QCA BEST WIFI SETTINGS](https://forum.dd-wrt.com/phpBB2/viewtopic.php?t=324014)
[^3]: [QCA Wireless Settings](https://wiki.dd-wrt.com/wiki/index.php/Atheros/ath_wireless_settings)
[^4]: []()