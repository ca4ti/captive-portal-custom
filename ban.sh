#!/bin/sh
macs=$(ndsctl clients | grep duration=0 | grep mac |  cut -d "=" -f 2)
PORTALCAPTIVEINTERFACE=guest
wlan=$(wifi status | grep $PORTALCAPTIVEINTERFACE -B 7 | cut -d\" -f 4 | head -n1)

for mac in $macs ; do
	#>5 min = 300
	test  $(($(date +%s) - $(ndsctl json $mac | grep active |  cut -d "\"" -f 4))) -gt 300 && ubus call hostapd.$wlan del_client "{'addr':'$mac', 'reason':5, 'deauth':true, 'ban_time': 10000}"
done
