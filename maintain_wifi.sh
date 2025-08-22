#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

# set -o errexit
set -o pipefail
set -o nounset
############### end of Boilerplate

##########
#
# script to monitor connectivity and restart WiFi when it goes away.
# 
# It requires an IP address to monitor and will ID the WiFi module
# in use and first try to restart WiFi and if that is not successful,
# will restart the host.

# check for required argument
if [ $# -eq 0 ]
then
    echo "Usage $0 ping_target" # host to ping to check network
    exit 1
else
    ip="$1"
    echo "pinging $ip to check connectivity at $(date +%Y-%m-%d-%H%M%S)"
fi

module=$(/sbin/lsmod|/bin/grep -E "^mac80211" | /bin/awk '{print $4}')
echo "WiFi module is \"$module\""

# loop test
missed_ping_count=0
while (:)
do
    if ! /bin/ping -c 1 "$ip" >/dev/null
    then
        echo "ping failed"
        (( missed_ping_count++ ))
        if [ "$missed_ping_count" -gt 5 ]
        then
            echo "trying wlan0 restart at $(date +%Y-%m-%d-%H%M%S)"
            /sbin/ifconfig wlan0 down
            /bin/sleep 1
            /sbin/rmmod "$module"
            /bin/sleep 1
            /sbin/modprobe "$module"
            /bin/sleep 3
            /sbin/ifconfig wlan0 up # not needed, probing the module brings it up

            sleep 30 # Wait to see if network comes back up

            if ! /bin/ping -c 1 "$ip" >/dev/null
            then
                echo "network not restored at $(date +%Y-%m-%d-%H%M%S)"
                /sbin/shutdown -r now
            fi
        fi
    else
        missed_ping_count=0
    fi
    sleep 15
done