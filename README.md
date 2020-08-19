# lab-sleeper
Concourse pipeline to power manager an ESXi home lab running on a single ESXi server.
The suspend job will suspent all running machines and power down the host. The resume job will send a Wake on LAN packet, wait for the host to become available and then power on any suspended VMs.

# Requirements
- Concourse CI
- Ability to route from Concourse containers to network where vCenter exists
- Wake on LAN enabled on the hosts

# Instructions

NOTE - VM names must not contain spaces. 

Update vars.yml to include the details of the host and modify timing if necessary.
Cron resource docs - https://github.com/pivotal-cf-experimental/cron-resource

You must already be logged into a team, with this assuming the team is called power-saver. 

Set pipeline with the correct host password
`fly -t power-saver sp -p power-saver -c ./pipelines/power-saver-pipeline.yml -l ./vars.yml -v host_password=MY_PASSWORD`

Unpause pipeline
`fly -t power-saver unpause-pipeline -p power-saver`

To prevent the schedules from running simply pause pipeline.
`fly -t power-saver pause-pipeline -p power-saver`

# Running from the CLI
From BASH based systems to be about to run a power up, power down command, add the following to your .bashrc, remembering to update you Concourse credentials

``

# Docker Build Instructions
Login to Docker Hub.
`docker login`

Build the image
`docker build . -t laidbackware/alpine-govc-wake`

Push back to Docker Hub
`docker push laidbackware/alpine-govc-wake`