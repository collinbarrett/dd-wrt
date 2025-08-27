# If following my blog, store 2x copies of this file.
#   1. /opt/vpn-refresh.sh
#   2. /jffs/etc/config/vpn-refresh.wanup
# https://collinmbarrett.com/protonvpn-dd-wrt-api-script/


#!/bin/sh

# specify PATH to run from cron
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/jffs/sbin:/jffs/bin:/jffs/usr/sbin:/jffs/usr/bin:/mmc/sbin:/mmc/bin:/mmc/usr/sbin:/mmc/usr/bin:/opt/sbin:/opt/bin:/opt/usr/sbin:/opt/usr/bin

# on router startup, wait for network to initially connect
echo "Short pause to wait for WAN connection..."
sleep 5

# verify not on VPN when fetching ProtonVPN server scores
# MYPUBLICIP=$(curl -s http://whatismyip.akamai.com/)
# echo "My public IP is ${MYPUBLICIP}"

# ProtonVPN server info query
LOGICALS='curl -sk -H "Cache-Control: no-cache" -H "Accept: application/json" https://api.protonmail.ch/vpn/logicals'

# query to get an optimal server
OPTIMAL_SERVER_QUERY=<<'QUERY'
.LogicalServers |
map(
    select(
        [.Status,.Tier] == [1, 2] and
        .City != null and
        (.City | test("(Atlanta|Dallas|Chicago)") # Now they have *two* problems.
    )
) |
sort_by(.Score, .Load)[0].Servers[0] |
"\(.EntryIP) \(.Label)"
QUERY

$LOGICALS | jq --raw-output "$OPTIMAL_SERVER_QUERY" | read -r $IPSTRING $LABELSTRING

if [ -n "$IPSTRING" ]
then
  IPSTRING="${IPSTRING%\"}"
  IP="${IPSTRING#\"}"

  CURRENTIP=$(nvram get openvpncl_remoteip)
  echo "The current OpenVPN server IP is ${CURRENTIP}"

  CURRENTUSERNAME=$(nvram get openvpncl_user)
  echo "The current OpenVPN username is ${CURRENTUSERNAME}"

  echo "The optimal OpenVPN server IP is ${IP}"

  # replace "THISISMYPROTONVPNUSERNAME" with your ProtonVPN username
  USERNAMEPRE="THISISMYPROTONVPNUSERNAME+b:"
  LABELSTRING="${LABELSTRING%\"}"
  LABEL="${LABELSTRING#\"}"
  USERNAME="$USERNAMEPRE$LABEL"
  echo "The optimal OpenVPN username is ${USERNAME}"

  if [ "$IP" != "$CURRENTIP" ] || [ "$USERNAME" != "$CURRENTUSERNAME" ]
  then
    echo "Connecting to $IP with $USERNAME..."

    # update OpenVPN config
    nvram set openvpncl_remoteip="${IP}"
    nvram set openvpncl_user="${USERNAME}"
    nvram commit

    # restart openvpn
    stopservice openvpn
    startservice openvpn
  else
    echo "The optimal ProtonVPN server has not changed. Aborting..."
  fi
else
  echo "Failed to fetch ProtonVPN server info. Aborting..."
fi
