#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v tree-sitter >/dev/null 2>&1; then
  echo "Tree-sitter CLI not found in PATH" >&2
  exit 1
fi

cd "$repo_dir"

tree-sitter test
tree-sitter query --quiet queries/neovim/highlights.scm examples/*.mpl
tree-sitter query --quiet queries/helix/highlights.scm examples/*.mpl
tree-sitter query --quiet queries/zed/highlights.scm examples/*.mpl
tree-sitter query --quiet queries/zed/brackets.scm examples/*.mpl
