#!/usr/bin/env bash

set -euo pipefail

KUBEVIRT_RELEASE_VERSION=$(
    curl --fail -s https://api.github.com/repos/kubevirt/kubevirt/releases \
        | jq -r '(.[].tag_name | select( test("-(rc|alpha|beta)") | not ) )' \
        | sort -rV | head -1 | xargs
)

[ -z "$KUBEVIRT_RELEASE_VERSION" ] && (echo "Failed to retrieve latest KubeVirt version!" ; exit 1)


# /repos/:owner/:repo/releases/tags/:tag

set +e
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

# shellcheck source=scripts/functions.sh
"$(dirname "${BASH_SOURCE[0]}")/create-release.sh" "$KUBEVIRT_RELEASE_VERSION"
