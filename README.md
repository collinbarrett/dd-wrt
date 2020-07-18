# dd-wrt

My home DD-WRT configuration for privacy, security, and performance. Documenting mostly so I can remember my preferred settings whenever I update/reset the router. All settings kept default unless otherwise noted below.

# Current Router

- [Netgear R7800](https://www.netgear.com/home/products/networking/wifi-routers/R7800.aspx).

# Current DD-WRT Build

- [v3.0-r73720 07/09/2020](https://forum.dd-wrt.com/phpBB2/viewtopic.php?t=325724)

# Setup

## Basic Setup

### Network Setup

#### Network Address Server Settings (DHCP)

_Route to private network reserved IPs to ensure ISP's DNS servers are not used. Dnsmasq is used to configure preferred DNS servers._

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
