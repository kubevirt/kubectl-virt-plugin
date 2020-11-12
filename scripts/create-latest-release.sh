#!/usr/bin/env bash

set -euo pipefail

function usage() {
    cat <<EOF
create krew packages for virtctl

usage: $0 [-h|--help]
       $0 [-d|--dry-run]

    options:
        -h|--help       show this help text
        -d|--dry-run    only create packages and test install, do not upload release
                        and create pull request

    example:

        $0

        creates krew virt packages from latest KubeVirt release

EOF
}

DRY_RUN=""
for i in "$@"; do
    case $i in
    -d | --dry-run)
        DRY_RUN="$1"
        shift
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    *) ;;

    esac
done

KUBEVIRT_RELEASE_VERSION=$(
    curl --fail -s https://api.github.com/repos/kubevirt/kubevirt/releases |
        jq -r '(.[].tag_name | select( test("-(rc|alpha|beta)") | not ) )' |
        sort -rV | head -1 | xargs
)

[ -z "$KUBEVIRT_RELEASE_VERSION" ] && (
    echo "Failed to retrieve latest KubeVirt version!"
    exit 1
)

# /repos/:owner/:repo/releases/tags/:tag

set +e
# shellcheck disable=SC2034  # Unused variable left for readability
release=$(
    curl --silent --fail \
        "https://api.github.com/repos/kubevirt/kubectl-virt-plugin/releases/tags/$KUBEVIRT_RELEASE_VERSION" \
        -H 'Content-Type: text/json; charset=utf-8' 2>&1
)
result=$?
set -e

if [ $result -eq 0 ]; then
    echo "Release $KUBEVIRT_RELEASE_VERSION already exists!"
    exit 0
fi

echo "Preparing packages for release $KUBEVIRT_RELEASE_VERSION..."

args="$KUBEVIRT_RELEASE_VERSION"
if [ -n "$DRY_RUN" ]; then
    args="$DRY_RUN $args"
fi

# shellcheck source=scripts/functions.sh
"$(dirname "${BASH_SOURCE[0]}")/create-release.sh" ${args}
