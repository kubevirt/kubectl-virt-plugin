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
# 5. test created install package on docker image

[ "$#" -eq 0 ] && usage "version must be provided!"
[ -z "$1" ] && usage "version must be provided!"

echo "Downloading binaries:"
echo $(download_virtctl_binaries "$1")

echo -e "\nCreating release packages for krew:"
echo $(create_release_packages "$1")

echo -e "\nCreating manifest yaml file for krew:"
echo $(create_krew_manifest_yaml "$1")

echo -e "\nTesting package install:"
echo $(test_linux_install_on_docker "$1")

echo -e "\nCreating github release:"
echo $(create_github_release "$1")
echo -e "\nRelease page is: https://github.com/dhiller/kubectl-virt-plugin/releases/tag/$1"

echo -e "\nCreating pull request:"
echo $(create_pull_request "$1")
