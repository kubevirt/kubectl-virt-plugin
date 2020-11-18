#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=scripts/functions
source "$(dirname "${BASH_SOURCE[0]}")/functions"

echo -e "\nCreating pull request:"
create_pull_request "$1"
