#!/usr/bin/env bash
set -euo pipefail

readonly HELIX_REV_DEFAULT="079a789e8cb08ead67f19e1971a1b7438b37354b"
repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cleanup=""

if [[ -n "${HELIX_SOURCE:-}" ]]; then
  helix_dir="$(cd "$HELIX_SOURCE" && pwd)"
else
  cleanup="$(mktemp -d)"
  trap 'rm -rf "$cleanup"' EXIT
  helix_dir="$cleanup/helix"
  git init -q "$helix_dir"
  git -C "$helix_dir" remote add origin https://github.com/helix-editor/helix.git
  git -C "$helix_dir" fetch -q --depth 1 origin "${HELIX_REV:-$HELIX_REV_DEFAULT}"
  git -C "$helix_dir" checkout -q --detach FETCH_HEAD
fi

if grep -q 'name = "mpl"' "$helix_dir/languages.toml"; then
  echo "Helix checkout already contains an MPL language entry" >&2
  exit 1
fi

cat >> "$helix_dir/languages.toml" <<EOF

[[language]]
name = "mpl"
language-id = "mpl"
scope = "source.mpl"
file-types = ["mpl"]
comment-tokens = ["//"]
grammar = "mpl"

[[grammar]]
name = "mpl"
source = { path = "$repo_dir" }
EOF

mkdir -p \
  "$helix_dir/.tree-sitter-config/tree-sitter" \
  "$helix_dir/runtime/grammars" \
  "$helix_dir/runtime/queries/mpl" \
  "$helix_dir/tests/query/highlights/mpl"
printf '{"parser-directories":["%s"]}\n' "$(dirname "$repo_dir")" \
  > "$helix_dir/.tree-sitter-config/tree-sitter/config.json"

XDG_CONFIG_HOME="$helix_dir/.tree-sitter-config" CC="${CC:-cc}" \
  npx --prefix "$repo_dir" tree-sitter build \
    -o "$helix_dir/runtime/grammars/mpl.so" "$repo_dir"
cp "$repo_dir/queries/helix/highlights.scm" \
  "$helix_dir/runtime/queries/mpl/highlights.scm"
cp "$repo_dir"/test/editors/helix/fixtures/*.mpl \
  "$helix_dir/tests/query/highlights/mpl/"

export HELIX_RUNTIME="$helix_dir/runtime"
(
  cd "$helix_dir"
  cargo xtask query-check mpl
  cargo xtask highlight-check mpl
)
