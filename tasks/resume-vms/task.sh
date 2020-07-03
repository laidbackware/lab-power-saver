#!/bin/bash

set -euo pipefail

HOSTS="$(govc ls /ha-datacenter/host)"

for host in ${HOSTS}
do
    if govc host.info ${host} |grep -i "Maintenance Mode"
     then
        govc host.maintenance.exit  ${host}
    else
        echo "Host ${host} is up and not in maintenance mode"
    fi
done

VMS="$(govc ls /ha-datacenter/vm)"

TO_RESUME=""

for vm in ${VMS}
do
    VM_STATE="$(govc vm.info ${vm})"
    echo "$VM_STATE"
    if echo "$VM_STATE" |grep -i "suspended"
    then
        TO_RESUME="$TO_RESUME $(echo "$VM_STATE" |grep -i "Path" |sed s'/  Path:         //')"
    fi
done

echo "$TO_RESUME"

if [ ! -z "$TO_RESUME" ]
then
    govc    vm.power -on -wait $TO_RESUME
else
    echo "No suspended VMs to resume"
fi



