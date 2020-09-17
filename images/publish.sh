#!/bin/bash

set -xeuo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd || exit 1)/common.sh"

docker push ${IMAGE_NAME}:latest
