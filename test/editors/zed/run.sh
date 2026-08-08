#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
runtime="$(mktemp -d)"
trap 'rm -rf "$runtime"' EXIT

mkdir -p "$runtime/config/tree-sitter"
printf '{"parser-directories":["%s"]}\n' "$(dirname "$repo_dir")" \
  > "$runtime/config/tree-sitter/config.json"

highlight_query="$repo_dir/queries/zed/highlights.scm"
bracket_query="$repo_dir/queries/zed/brackets.scm"
bracket_fixture="$repo_dir/test/editors/zed/fixtures/brackets.mpl"

while IFS= read -r capture; do
  case "$capture" in
    @attribute | @boolean | @comment | @constant | @function | @keyword | \
    @number | @operator | @property | @punctuation.bracket | \
    @punctuation.delimiter | @punctuation.special | @string | \
    @string.escape | @string.regex | @type | @type.builtin | @variable | \
    @variable.parameter)
      ;;
    *)
      echo "Unsupported Zed highlight capture: $capture" >&2
      exit 1
      ;;
  esac
done < <(grep -oE '@[A-Za-z0-9_.-]+' "$highlight_query" | sort -u)

XDG_CONFIG_HOME="$runtime/config" \
  npx --prefix "$repo_dir" tree-sitter query --quiet \
    "$highlight_query" \
    "$repo_dir"/examples/*.mpl \
    "$repo_dir"/test/highlight/*.mpl

XDG_CONFIG_HOME="$runtime/config" \
  npx --prefix "$repo_dir" tree-sitter query \
    "$bracket_query" "$bracket_fixture" \
    > "$runtime/brackets.out"

for delimiter in \
  'text: `(`' \
  'text: `)`' \
  'text: `[`' \
  'text: `]`' \
  'text: `{`' \
  'text: `}`' \
  'text: `${`' \
  'text: `"`' \
  'text: ```'
do
  if ! grep -Fq "$delimiter" "$runtime/brackets.out"; then
    echo "Missing Zed bracket capture: $delimiter" >&2
    exit 1
  fi
done

if [[ "$(grep -Fc 'text: `<`' "$runtime/brackets.out")" -ne 1 ]]; then
  echo "Expected only the Option type's opening angle bracket to be captured" >&2
  exit 1
fi

if [[ "$(grep -Fc 'text: `>`' "$runtime/brackets.out")" -ne 1 ]]; then
  echo "Expected only the Option type's closing angle bracket to be captured" >&2
  exit 1
fi
