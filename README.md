# lab-sleeper
Concourse pipeline to power manager an ESXi home lab

# Set pipeline
Must already be logged into a team. This will set in the main team.
`GIT_PRIVATE_KEY="$(cat ~/.ssh/git)"`
`fly -t main sp -p power-saver -c ./pipelines/power-saver-pipeline.yml -l ./vars.yml -v host_password=Pass123! -v git_private_key="${GIT_PRIVATE_KEY}"`
`fly -t main up -p power-saver`

# Docker build
Login to docker hub
`docker build . -t laidbackware/alpine-govc-wake`
`docker push laidbackware/alpine-govc-wake`