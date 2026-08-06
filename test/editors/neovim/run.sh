#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
runtime="$(mktemp -d)"
trap 'rm -rf "$runtime"' EXIT

mkdir -p \
  "$runtime/config/tree-sitter" \
  "$runtime/parser" \
  "$runtime/queries/mpl"
printf '{"parser-directories":["%s"]}\n' "$(dirname "$repo_dir")" \
  > "$runtime/config/tree-sitter/config.json"
XDG_CONFIG_HOME="$runtime/config" CC="${CC:-cc}" \
  npx --prefix "$repo_dir" tree-sitter build \
    -o "$runtime/parser/mpl.so" "$repo_dir"
cp "$repo_dir/queries/neovim/highlights.scm" \
  "$runtime/queries/mpl/highlights.scm"

MPL_NVIM_RUNTIME="$runtime" \
MPL_NVIM_FIXTURES="$repo_dir/test/editors/neovim/fixtures" \
  "${NVIM:-nvim}" --headless -u NONE -l "$repo_dir/test/editors/neovim/runner.lua"
