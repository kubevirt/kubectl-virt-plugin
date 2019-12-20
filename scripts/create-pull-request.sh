#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=scripts/functions.sh
source "$(dirname "${BASH_SOURCE[0]}")/functions"

echo -e "\nCreating pull request:"
echo $(create_pull_request "$1")
