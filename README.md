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

##### WAN Setup

###### WAN Connection Type

- Ignore WAN DNS: `✓`[^5]

##### Network Setup

###### Dynamic Host Configuration Protocol (DHCP)

- Forced DNS Redirection: `✓`[^6]
- Forced DNS Redirection DoT: `✓`[^6]

###### NTP Client Settings

- Time Zone: {REDACTED}

#### Tunnels

1. Import Configuration from ProtonVPN
2. Configure
   - DNS Servers via Tunnel: {empty}
   - Kill Switch: `✓`[^5]
   - Allow Clients WAN Access: {unchecked}[^5]
   - Source Routing (PBR): `Route Selected sources via WAN`[^5]
   - Source for PBR: `192.168.1.63`[^5]
   - Watchdog: `Enable`[^5]
     - Server IP / Name: `1.1.1.1`[^5]

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
- TX Power: `30`[^3]
- Protection Mode: `RTS/CTS`[^3]
- RTS Threshold: `Enable`[^3]
- Threshold: `980`[^3]
- Short Preamble: `Enable`[^3]
- Single User Beamforming: `Enable`[^3]
- Beacon Interval: `300`[^3]
- DTIM Interval: `1`[^3]
- Airtime Fairness: `Disable`[^1]
- Sensitivity Range / ACK Timing: `3150`[^2]

##### Virtual Interfaces wlan0.1

- Service Set Identifier (SSID): {REDACTED}
- Advanced Settings: `✓`
- Protection Mode: `RTS/CTS`[^3]
- RTS Threshold: `Enable`[^3]
- Threshold: `980`[^3]
- AP Isolation: `Enable`[^3]
- DTIM Interval: `1`[^3]

##### Physical Interface wlan1 [2.4 GHz]

- Service Set Identifier (SSID): {REDACTED}
- Network Mode: `N / G Mixed`[^3]
- Channel: {least congested, don't use Auto}[^3]
- TurboQAM (QAM256): `Enable`[^3]
- Advanced Settings: `✓`
- Firmware Type: `VANILLA`[^1]
- TX Power: `30`[^3]
- Protection Mode: `RTS/CTS`[^3]
- RTS Threshold: `Enable`[^3]
- Threshold: `980`[^3]
- Short Preamble: `Enable`[^3]
- Beacon Interval: `400`[^3]
- DTIM Interval: `1`[^3]
- Airtime Fairness: `Disable`[^1]
- Sensitivity Range / ACK Timing: `3150`[^2]

##### Virtual Interfaces wlan1.1

- Service Set Identifier (SSID): {REDACTED}
- Advanced Settings: `✓`
- Protection Mode: `RTS/CTS`[^3]
- RTS Threshold: `Enable`[^3]
- Threshold: `980`[^3]
- AP Isolation: `Enable`[^3]
- DTIM Interval: `1`[^3]

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
- Custom Config: `vendor_vht=1`[^3]

### Services

#### Services

##### DHCP Server Setup

- Static Leases:[^5]

  | MAC Address | Hostname | IP Address   | Lease Expiration |
  |-------------|----------|--------------|------------------|
  | {REDACTED}  | tv       | 192.168.1.63 |                  |

##### Dnsmasq Infrastructure

- Cache DNSSEC Data: `Enable`
- Validate DNS Replies (DNSSEC): `Enable`
- Query DNS in Strict Order: `Enable`
- Maximum Cached Entries: `10000`
- Additional Options:[^4] [^5] [^6]

    ```
    no-resolv
       
    # NextDNS
    server=45.90.30.0
    server=45.90.28.0
    add-cpe-id={REDACTED}

    # https://github.com/collinbarrett/dd-wrt/issues/1
    neg-ttl=300
    
    # end 
    ```

### Administration

#### Keep Alive

##### Schedule Reboot

- Enable: `✓`
- At a Set Time: `✓` `02` `00` `Monday`

[^1]: [DD-WRT Netgear R7800 Install Guide](https://forum.dd-wrt.com/phpBB2/viewtopic.php?t=320614)
[^2]: [QCA BEST WIFI SETTINGS](https://forum.dd-wrt.com/phpBB2/viewtopic.php?t=324014)
[^3]: [QCA Wireless Settings](https://wiki.dd-wrt.com/wiki/index.php/Atheros/ath_wireless_settings)
[^4]: [NextDNS Setup Guide](https://my.nextdns.io/{REDACTED}/setup)
[^5]: [WireGuard client setup guide](https://forum.dd-wrt.com/phpBB2/viewtopic.php?t=324624)
[^6]: [VPN and DNS guide](https://forum.dd-wrt.com/phpBB2/viewtopic.php?t=331017)
