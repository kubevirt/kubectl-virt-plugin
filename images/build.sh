#!/bin/bash

set -xeuo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd || exit 1)/common.sh"

docker build "$SCRIPT_DIR/$1" -t ${IMAGE_NAME}
