#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=scripts/functions.sh
source "$(dirname "${BASH_SOURCE[0]}")/functions"

[ "$#" -eq 0 ] && usage "version must be provided!"
[ -z "$1" ] && usage "version must be provided!"

(
    cd "$(get_output_dir)" || (echo "Failed to cd into $(get_output_dir)"; exit 1)

    repo_dir="$(get_output_dir)/krew-index"
    [ -d "$repo_dir" ] && rm -rf "$repo_dir"

    origin='github.com/kubernetes-sigs/krew-index.git'
    git clone "https://$origin"

    cd "$repo_dir" || (echo "Failed to cd into $repo_dir"; exit 1)
    git config user.email "daniel.hiller.1972@gmail.com"
    git config user.name "Daniel Hiller"

    fork='github.com/dhiller/krew-index.git'
    git remote add fork "https://$fork"

    branch_name="bump-virtctl-to-$1"
    git checkout -b "$branch_name"

    cp "$(get_release_dir "$1")/virt.yaml" "$repo_dir"
    git add virt.yaml

    title="Update virt (KubeVirt virtctl plugin package) to $1"
    git commit -m "$title"
    git push "https://$(get_github_auth)@$fork" || exit 1

    curl -v --fail -u "$(get_github_auth)" -X POST \
        "https://api.github.com/repos/kubernetes-sigs/krew-index/pulls" \
        -H 'Content-Type: text/json; charset=utf-8' \
        --data @- 2>&1 << EOF
{
    "title": "${title}"
    "head": "${branch_name}",
    "base": "master",
    "body": "See https://github.com/kubevirt/kubevirt/releases/tag/${1}",
    "maintainer_can_modify": true,
    "draft": false
}
EOF

)
