#!/bin/bash

# Usage: resolve.sh @/src/cli/main.sh
# Output: /absolute/path/to/repo/src/cli/main.sh

# Resolve @ to the root of the Git repo
resolve_path() {
  local input="$1"
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null)

  if [[ -z "$root" ]]; then
    echo "Not in a Git repo." >&2
    return 1
  fi

  local resolved="${input/@/$root}"
  echo "$resolved"
}

resolve_path "$1"
