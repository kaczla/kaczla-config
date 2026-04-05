#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage: $(basename "$0") [BASE_DIR]"
    echo
    echo "Finds git repositories in BASE_DIR and pulls latest changes with"
    echo "'git pull -p -r', skipping repositories with uncommitted changes."
    echo
    echo "Arguments:"
    echo "  BASE_DIR    Directory to search for repositories (default: current directory)"
    exit 1
}

if [[ $# -gt 1 ]]; then
    usage
fi

BASE_DIR="${1:-$(pwd)}"

while IFS= read -r git_dir; do
    dir="$(dirname "$git_dir")"

    echo "==> Processing: $dir"

    cd "$dir"

    # Skip if there are uncommitted changes (ignores untracked files)
    if ! git diff --quiet HEAD; then
        echo "  [SKIP] Uncommitted changes detected"
        cd - > /dev/null
        continue
    fi

    if ! git pull -p -r; then
        echo "  [WARN] git pull failed in $dir"
        cd - > /dev/null
        continue
    fi

    echo "  [OK] Pulled successfully"

    cd - > /dev/null

done < <(find "$BASE_DIR" -mindepth 2 -maxdepth 2 -name ".git" -type d)

echo "Done."
