#!/usr/bin/env bash
set -euo pipefail

usage() {
    echo "Usage: $(basename "$0") [--no-push] [BASE_DIR]"
    echo
    echo "Finds Python projects with uv.lock in BASE_DIR, pulls latest changes,"
    echo "updates dependencies with 'uv sync -U', and commits+pushes any lock file changes."
    echo
    echo "Options:"
    echo "  --no-push   Commit changes but skip git push"
    echo
    echo "Arguments:"
    echo "  BASE_DIR    Directory to search for projects (default: current directory)"
    exit 1
}

NO_PUSH=false
BASE_DIR=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --no-push)
            NO_PUSH=true
            shift
            ;;
        -*)
            usage
            ;;
        *)
            BASE_DIR="$1"
            shift
            ;;
    esac
done

BASE_DIR="${BASE_DIR:-$(pwd)}"

while IFS= read -r lock_file; do
    dir="$(dirname "$lock_file")"

    echo "==> Processing: $dir"

    cd "$dir"

    # Skip if there are uncommitted changes (ignores untracked files)
    if ! git diff --quiet HEAD; then
        echo "  [SKIP] Uncommitted changes detected"
        cd - > /dev/null
        continue
    fi

    # Sync with remote before updating
    if ! git pull -p -r; then
        echo "  [WARN] git pull failed in $dir, skipping"
        cd - > /dev/null
        continue
    fi

    # Update dependencies
    if ! uv sync -U; then
        echo "  [WARN] uv sync -U failed in $dir, skipping"
        cd - > /dev/null
        continue
    fi

    # Check if uv.lock changed
    if git diff --quiet uv.lock 2>/dev/null; then
        echo "  [OK] No changes in uv.lock"
        cd - > /dev/null
        continue
    fi

    echo "  [INFO] uv.lock changed, committing..."

    git add uv.lock

    # Include pyproject.toml if it was also modified
    if ! git diff --quiet pyproject.toml 2>/dev/null; then
        git add pyproject.toml
    fi

    git commit -m "chore: update Python dependencies"

    if [[ "$NO_PUSH" == true ]]; then
        echo "  [OK] Committed (push skipped)"
    else
        git push
        echo "  [OK] Committed and pushed"
    fi

    cd - > /dev/null

done < <(find "$BASE_DIR" -mindepth 2 -maxdepth 2 -name "uv.lock")

echo "Done."
