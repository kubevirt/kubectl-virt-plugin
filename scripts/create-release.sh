#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=scripts/functions.sh
source "$(dirname "${BASH_SOURCE[0]}")/functions"

function usage() {
    cat <<EOF
create krew packages for virtctl

usage: $0 [-h|--help]
       $0 [-d|--dry-run] <semver>

    options:
        -h|--help       show this help text
        -d|--dry-run    only create packages and test install, do not upload release
                        and create pull request

    example:

        $0 v0.30.0

        creates krew virt packages from KubeVirt source release v0.30.0

EOF
}

DRY_RUN=""
for i in "$@"; do
    case $i in
        -d|--dry-run)
        DRY_RUN="true"
        shift
        ;;
        -h|--help)
        usage
        exit 0
        ;;
        *)
        ;;
    esac
done

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
download_virtctl_binaries "$1"

echo -e "\nCreating release packages for krew:"
create_release_packages "$1"

echo -e "\nCreating manifest yaml file for krew:"
create_krew_manifest_yaml "$1"

echo -e "\nTesting package install:"
test_linux_install_on_docker "$1"

if [[ "$DRY_RUN" == "true" ]]; then
    echo "Dry run - skipping release creation"
    exit 1
fi

echo -e "\nCreating github release:"
create_github_release "$1"
echo -e "\nRelease page is: https://github.com/kubevirt/kubectl-virt-plugin/releases/tag/$1"

echo -e "\nValidating manifest with release:"
validate-krew-manifest -manifest "$(get_manifest_yaml "$1")"

echo -e "\nCreating pull request:"
create_pull_request "$1"
