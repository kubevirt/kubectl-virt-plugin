#!/bin/bash

set -xeuo pipefail

set -xeuo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd || exit 1)/common.sh"

docker pull ${IMAGE_NAME}
sha_id=$(docker images --digests ${IMAGE_NAME} | grep 'latest ' | awk '{ print $3 }')
echo "sha: ${sha_id}"

sed -i -E 's#'"${IMAGE_NAME}"'@sha256\:[a-z0-9]+#'"${IMAGE_NAME}@$sha_id"'#g' ../scripts/functions

