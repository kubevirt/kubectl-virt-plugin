#!/usr/bin/env bash

# shellcheck source=scripts/functions.sh
source "$(dirname "${BASH_SOURCE[0]}")/functions"

[ "$#" -eq 0 ] && usage "version must be provided!"
[ -z "$1" ] && usage "version must be provided!"

create_release_packages "$1"