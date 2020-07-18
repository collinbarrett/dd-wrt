# DD-WRT Configuration

My home DD-WRT configuration for privacy, security, and performance. Documenting mostly so I can remember my preferred settings whenever I update/reset the router.

All settings are kept as default unless otherwise noted below. Sensitive information is annotated with "{REDACTED}".

## Current Router

- [Netgear R7800](https://www.netgear.com/home/products/networking/wifi-routers/R7800.aspx).

## Current DD-WRT Build

- [v3.0-r73720 07/09/2020](https://forum.dd-wrt.com/phpBB2/viewtopic.php?t=325724)

## 3rd-Party Services

- [ProtonVPN](https://protonvpn.com/)
- [NextDNS](https://nextdns.io/)

## Select Optimal ProtonVPN Server

- Configure via ProtonVPN API per [my blog](https://collinmbarrett.com/protonvpn-dd-wrt-api-script/).

## TODO

- Block DNS requests when VPN tunnel is down.

# Setup

## Basic Setup

### Network Setup

#### Network Address Server Settings (DHCP)

_Route DNS to private network reserved IPs to ensure ISP's DNS servers are not used. Dnsmasq is used to configure preferred DNS servers._

- Static DNS 1: `10.0.0.0`
- Static DNS 2: `10.0.0.1`
- Static DNS 3: `10.0.0.2`
- Use DNSMasq for DNS: `☑`
- DHCP-Authoritative: `☑`
- Recursive DNS Resolving (Unbound): `☐`
- Forced DNS Redirection: `☑`

#### Time Settings

- Time Zone: `US/Central`
- Server IP/Name: `pool.ntp.org`

# Wireless

TBD

Use guidance from [here](https://forum.dd-wrt.com/wiki/index.php/QCA_wireless_settings).

# Services

## Services

### Services Management

#### DHCP Server

_Since many streaming services (e.g., Netflix) block VPNs, assign a static lease to the TV so that it can bypass OpenVPN client via policy-based routing._

**Static Leases**
| MAC Address | Hostname | IP Address | Client Lease Expiration |
|-------------|----------|--------------|-------------------------|
| {REDACTED} | tv | 192.168.1.99 | |

#### Dnsmasq

- No DNS Rebind: `☑`
- Query DNS in Strict Order: `☐`
- Maximum Cached Entries: `10000`

**Additional Dnsmasq Options**

```
# Block attempts to resolve domains via ISP.
address=/.hsd1.tn.comcast.net/::

# Block non-domain lookups.
domain-needed

# Override default synchronous logging which blocks subsequent requests.
log-async=5

# Send DNS requests to all servers to use fastest response.
all-servers

# Use nextdns.io for DNS.
no-resolv
bogus-priv
server=45.90.30.0
server=45.90.28.0
add-cpe-id={REDACTED}
```

## VPN

### OpenVPN Client

Configure using the [latest guidance from ProtonVPN](https://protonvpn.com/support/vpn-router-ddwrt/) except for customizations below.

- Server IP/Name: `us.protonvpn.com`
- Port: `443`

**Additional Config**

```
...

# Route DNS requests from dnsmasq through OpenVPN client.
route 45.90.30.0 255.255.255.255
route 45.90.28.0 255.255.255.255
```

**Policy-Based Routing**

```
# Route DHCP-assigned clients through OpenVPN client.
192.168.1.100/30
192.168.1.104/29
192.168.1.112/28
192.168.1.128/28
192.168.1.144/30
192.168.1.148/31
```

# Security

## Firewall

### Security

#### Firewall Protection

- SPI Firewall: `Enable`

#### Additional Filters

- Filter Proxy: `☑`
- Filter Cookies: `☑`
- Filter Java Applets: `☑`
- Filter ActiveX: `☑`
- Filter TOS/DSCP: `☑`
- ARP Spoofing Protection: `☑`

#### Block WAN Requests

- Block Anonymous WAN Requests (ping): `☑`
- Filter Multicast: `☑`
- Filter WAN NAT Redirection: `☑`
- Filter IDENT (Port 113): `☑`
- Block WAN SNMP access: `☑`

#### Impede WAN DoS/Bruteforce

- Limit SSH Access: `☑`
- Limit Telnet Access: `☑`
- Limit PPTP Server Access: `☑`
- Limit FTP Server Access: `☑`

## VPN Passthrough

### Vitual Private Network (VPN)

#### VPN Passthrough

- IPSec Passthrough: `Disable`
- PPTP Passthrough: `Disable`
- L2TP Passthrough: `Disable`

# Administration

## Keep Alive

### WDS/Connection Watchdog

_If WAN connectivity is lost (either VPN or ISP connection break), reboot the router. If it is an ISP issue, this likely will not help. If the VPN server I was connected to goes down, rebooting the router will re-connect to a new server._

- Enable Watchdog: `Enable`
- Interval (in seconds): `60`
- IP Addresses: `1.1.1.1`

## Commands

### Diagnostics

#### Startup

```
# Start Entware.
# https://wiki.dd-wrt.com/wiki/index.php/Installing_Entware
sleep 10
/opt/etc/init.d/rc.unslung start
```

#### Firewall

```
LAN_IP=`nvram get lan_ipaddr`

# Block DNS requests to anywhere but my dnsmasq.
iptables -t nat -A PREROUTING -i br0 -p udp --dport 53 -j DNAT --to $LAN_IP
iptables -t nat -A PREROUTING -i br0 -p tcp --dport 53 -j DNAT --to $LAN_IP

WAN_IF=`nvram get wan_iface`

# Block requests not bound for OpenVPN Client.
iptables -I FORWARD -i br0 -o $WAN_IF -j REJECT --reject-with icmp-host-prohibited
iptables -I FORWARD -i br0 -p tcp -o $WAN_IF -j REJECT --reject-with tcp-reset
iptables -I FORWARD -i br0 -p udp -o $WAN_IF -j REJECT --reject-with udp-reset

# Allow TV to bypass OpenVPN Client.
iptables -I FORWARD -i br0 -o $WAN_IF -s 192.168.1.99 -j ACCEPT
```
