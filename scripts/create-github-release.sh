#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=scripts/functions.sh
source "$(dirname "${BASH_SOURCE[0]}")/functions"

[ "$#" -eq 0 ] && usage "version must be provided!"
[ -z "$1" ] && usage "version must be provided!"

version="$1"

release_response=$(
    curl --silent --fail -u "dhiller:$GH_KUBECTL_VIRT_PLUGIN_TOKEN" -X POST \
        "https://api.github.com/repos/dhiller/kubectl-virt-plugin/releases" \
        -H 'Content-Type: text/json; charset=utf-8' \
        --data @- 2>&1 << EOF
{
  "tag_name": "${version}",
  "target_commitish": "master",
  "name": "${version} kubectl virt plugin",
  "body": "See https://github.com/kubevirt/kubevirt/releases/tag/${version}",
  "draft": false,
  "prerelease": false
}
EOF
)

release_id=$(echo $release_response | jq -r .url | grep -oE '[0-9]+')
upload_url=$(echo $release_response | jq -r .upload_url)

for file in $(get_release_packages $version); do
    platform_filename=$(basename $file)
    target_upload_url=$(echo $upload_url | sed 's/{.*/?name='"$platform_filename"'\&label='"$platform_filename"'/')
    curl -v --fail -u "dhiller:$GH_KUBECTL_VIRT_PLUGIN_TOKEN" -X POST \
        -H 'Content-Type: application/gzip' \
        "$target_upload_url" \
        --data-binary "@$file"
done

#curl -v --fail -u "dhiller:$GH_KUBECTL_VIRT_PLUGIN_TOKEN" -X DELETE \
#    "https://api.github.com/repos/dhiller/kubectl-virt-plugin/releases/${release_id}"
