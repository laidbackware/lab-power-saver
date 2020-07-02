# lab-sleeper
Concourse pipeline to power manager an ESXi home lab running on a single ESXi server.
The suspend job will suspent all running machines and power down the host. The resume job will send a Wake on LAN packet, wait for the host to become available and then power on any suspended VMs.

# Requirements
- Concourse CI
- Ability to route from Concourse containers to network where vCenter exists
- Wake on LAN enabled on the hosts

# Instructions
Update vars.yml to include the details of the host and modify timing if necessary.
Cron resource docs - https://github.com/pivotal-cf-experimental/cron-resource

You must already be logged into a team. 

Set pipeline with the correct host password
`fly -t main sp -p power-saver -c ./pipelines/power-saver-pipeline.yml -l ./vars.yml -v host_password=MY_PASSWORD`

Unpause pipeline
`fly -t main up -p power-saver`

To prevent one of the schedules from running simply pause the respective job in Concourse. Note that on un-pausing the job will trigger if a schedule has recently passed.

# Docker Build Instructions
Login to Docker Hub.
`docker login`

Build the image
`docker build . -t laidbackware/alpine-govc-wake`

Push back to Docker Hub
`docker push laidbackware/alpine-govc-wake`