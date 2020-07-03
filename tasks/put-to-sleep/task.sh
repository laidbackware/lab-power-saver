#!/bin/bash

set -euxo pipefail

if $(curl -k --output /dev/null --silent --head --fail -m 5 https://${HOST_IP})
then
    echo "Host ${HOST_IP} is online, attempting to suspend"
else
    echo "Host is already offline"
    exit 0
fi


VMS="$(govc ls /ha-datacenter/vm)"

TO_SUSPEND=""

for vm in ${VMS}
do
    VM_STATE="$(govc vm.info ${vm})"
    echo "$VM_STATE"
    if echo "$VM_STATE" |grep -i "poweredOn"
    then
        TO_SUSPEND="$TO_SUSPEND $(echo "$VM_STATE" |grep -i "Path" |sed s'/  Path:         //')"
    fi
done

echo "$TO_SUSPEND"

if [ ! -z "$TO_SUSPEND" ]
then
    govc    vm.power -suspend -wait $TO_SUSPEND
fi


HOSTS="$(govc ls /ha-datacenter/host)"

for host in ${HOSTS}
do
    if ! govc host.info ${host} |grep -i "Maintenance Mode"
     then
        govc host.maintenance.enter  ${host}
    else
        echo "Host ${host} is already in maintenance mode"
    fi
    govc host.shutdown ${host}
done

