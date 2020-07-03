#!/bin/bash

set -euo pipefail

if $(curl -k --output /dev/null --silent --head --fail -m 5 https://${HOST_IP})
then
    echo "Host is already online, exiting cleanly"
    exit 0
else
    echo "Host ${HOST_IP} is not online, attempting to wake up"
fi

# Calculate the broadcast address of the network to allow the WOL packet to be sent to the correct network
NETWORK_BROADCAST=$(ipcalc -b ${HOST_IP}/${HOST_CIDR_INT} |grep Broadcast|cut -d ' ' -f2)

echo "sending wake packet to broadcast adress ${NETWORK_BROADCAST} for MAC address ${HOST_MAC}"

# Set wake packet 
awake -b ${NETWORK_BROADCAST} ${HOST_MAC}

# Check to see when host comes online and timeout after 5 minutes
ATTEMPT_COUNTER=0
MAX_ATTEMPTS=60

until $(curl -k --output /dev/null --silent --head --fail https://${HOST_IP}); do
    if [ ${ATTEMPT_COUNTER} -eq ${MAX_ATTEMPTS} ];then
      echo "Max attempts reached"
      exit 1
    fi
    ATTEMPT_COUNTER=$(expr ${ATTEMPT_COUNTER} + 1)
    CURRENT_TRY=$(expr ${MAX_ATTEMPTS} - ${ATTEMPT_COUNTER})
    echo "Host ${HOST_IP} not online yet, ${CURRENT_TRY} more retries left"
    sleep 5
done

echo "Host ${HOST_IP} online!"
