#!/bin/bash

set -euo pipefail

docker build . -t dhiller/kubectl-krew

# test image
docker run --rm dhiller/kubectl-krew:latest kubectl krew version

docker push dhiller/kubectl-krew:latest

sha_id=$(docker images --digests dhiller/kubectl-krew | grep 'latest ' | awk '{ print $3 }')

sed -i -E 's/dhiller\/kubectl-krew@sha256\:[a-z0-9]+/'"dhiller\/kubectl-krew@$sha_id"'/g' ../scripts/functions

