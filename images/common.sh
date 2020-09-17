#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd || exit 1)
BASE_DIR="${SCRIPT_DIR/\/kubectl-virt-plugin\/*/\/kubectl-virt-plugin}"

[ ! -d "$SCRIPT_DIR/$1/config.sh" ] || exit 1

source "$SCRIPT_DIR/$1/config.sh"
