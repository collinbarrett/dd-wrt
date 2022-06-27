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

# fetch ProtonVPN server info
LOGICALS=$(curl -sk -H "Cache-Control: no-cache" -H "Accept: application/json" https://api.protonmail.ch/vpn/logicals)

# query for optimal server
SERVER=$(echo "$LOGICALS" | jq '.LogicalServers | map(select(.Status == 1 and .Tier == 2 and .City != null and (.City | (contains("Atlanta") or contains("Dallas") or contains("Chicago"))))) | [sort_by(.Score, .Load)[]][0] | .Servers[0]')
IPSTRING=$(echo "$SERVER" | jq '.EntryIP')

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
  LABELSTRING=$(echo "$SERVER" | jq '.Label')
  LABELSTRING="${LABELSTRING%\"}"
  LABEL="${LABELSTRING#\"}"
  USERNAME="$USERNAMEPRE$LABEL"
  echo "The optimal OpenVPN username is ${USERNAME}"

  if [ "$IP" != "$CURRENTIP" ] || [ "$USERNAME" != "$CURRENTUSERNAME" ]
  #if [ 1 == 2 ]
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
