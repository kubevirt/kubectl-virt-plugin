#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=scripts/functions.sh
source "$(dirname "${BASH_SOURCE[0]}")/functions"

# sketch:
#
# 1.    download the binaries from the release
#       source is i.e. https://github.com/kubevirt/kubevirt/releases/tag/v0.17.2

# 2. create release binaries that are consumable from krew (i.e. .tar.gz)
# 3. calculate the sha256sums
# 4. envsubst all of these into the virt.yaml

[ "$#" -eq 0 ] && usage "version must be provided!"
[ -z "$1" ] && usage "version must be provided!"

echo "Downloading binaries:"
echo $(download_virtctl_binaries "$1")

echo -e "\nCreating release packages for krew:"
echo $(create_release_packages "$1")

echo -e "\nCreating manifest yaml file for krew:"
echo $(create_krew_manifest_yaml "$1")