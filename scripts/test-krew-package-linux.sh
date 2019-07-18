#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=scripts/functions.sh
source "$(dirname "${BASH_SOURCE[0]}")/functions"

[ "$#" -eq 0 ] && usage "version must be provided!"
[ -z "$1" ] && usage "version must be provided!"

release_dir=$(get_release_dir "$1")
cd "$BASE_DIR/test"
mkdir -p package
cp "$release_dir/virt.yaml" package/
cp "$release_dir/virtctl-$1-linux-amd64.tar.gz" package/virtctl.tar.gz || ( echo "Failed to copy package"; exit 1 )

echo "Building docker test image"
docker build . -t kubectl-krew > docker.log 2>&1 || ( echo "Failed to build docker image for test"; cat docker.log; exit 1 )

echo -n "Testing krew package install on docker image: "
docker run -v $(pwd)/package:/virt_package kubectl-krew:latest kubectl krew install --manifest=/virt_package/virt.yaml --archive=/virt_package/virtctl.tar.gz > test.log 2>&1 || ( echo "FAILED"; cat test.log; exit 1 )

echo "OK"