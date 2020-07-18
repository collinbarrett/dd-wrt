# DD-WRT Configuration

My home DD-WRT configuration for privacy, security, and performance. Documenting mostly so I can remember my preferred settings whenever I update/reset the router.

All settings are kept as default unless otherwise noted below. Sensitive information is annotated with "{REDACTED}".

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

# Services

## Services

### Services Management

#### DHCP Server

_Assign a static lease to the TV so that it can bypass the OpenVPN client via policy-based routing to support streaming services that block VPN access._

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
