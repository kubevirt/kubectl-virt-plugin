#!/usr/bin/env bash

set -euo pipefail

KUBEVIRT_VERSION=$(curl --fail -s 'https://api.github.com/repos/kubevirt/kubevirt/releases'|grep tag_name|head -1 | awk -F':' '{print $2}' | sed 's/,//' | xargs)

[ -z "$KUBEVIRT_VERSION" ] && (echo "Failed to retrieve latest KubeVirt version!" ; exit 1)

echo "Preparing packages for release $KUBEVIRT_VERSION..."

# shellcheck source=scripts/functions.sh
"$(dirname "${BASH_SOURCE[0]}")/create-release.sh" "$KUBEVIRT_VERSION"
