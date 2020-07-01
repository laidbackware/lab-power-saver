#!/bin/bash

set -euxo pipefail

if $(curl -k --output /dev/null --silent --head --fail -m 5 https://${HOST_IP})
then
    echo "Host is already online"
    exit 0
fi

NETWORK_BROADCAST=$(ipcalc -b ${HOST_IP}/${HOST_CIDR_INT} |grep Broadcast|cut -d ' ' -f2)

echo ${NETWORK_BROADCAST}

awake -b ${NETWORK_BROADCAST} 38:2c:4a:71:b9:34

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
