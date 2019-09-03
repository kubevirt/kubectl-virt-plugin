#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=scripts/functions.sh
source "$(dirname "${BASH_SOURCE[0]}")/functions"

mkdir -p $BASE_DIR/out/build/

echo "Building docker test image"
docker build "$BASE_DIR/test_install" -t dhiller/kubectl-krew >$BASE_DIR/out/build/docker.log 2>&1 || (
    echo "Failed to build docker image for test"
    cat $BASE_DIR/out/build/docker.log
    exit 1
)

echo "Pushing docker test image"
docker push dhiller/kubectl-krew:latest

