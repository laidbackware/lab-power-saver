# lab-sleeper
Concourse pipeline to power manager an ESXi home lab

# Set pipeline
Must already be logged into a team. This will set in the main team.


# Docker build
Login to docker hub
`docker build . -t laidbackware/alpine-govc-wake`
`docker push laidbackware/alpine-govc-wake`