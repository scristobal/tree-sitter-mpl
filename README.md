# tree-sitter-mpl

Tree-sitter grammar and highlighting queries for the [Axiom Metrics Processing Language (MPL)](https://axiom.co/docs/mpl).

Generated parser sources are committed, so applications embedding the parser do not need Node.js or the Tree-sitter CLI. The development commands below require Node.js/npm and a C compiler; `npm ci` installs the project-local Tree-sitter CLI (currently 0.25.x).

## Try highlighting

Tree-sitter CLI 0.25 discovers parsers through its configuration. From the repository root:

```sh
npm ci
npx tree-sitter init-config # only if you do not already have a config
```

Edit the generated `config.json` and add the **parent directory** containing this repository to `parser-directories`. For example, if the clone is `/home/me/src/tree-sitter-mpl`:

```json
{
  "parser-directories": [
    "/home/me/src"
  ]
}
```

Pointing `parser-directories` at the repository itself will not discover it. Confirm discovery and highlight the examples with:

```sh
npx tree-sitter dump-languages
npx tree-sitter highlight --scope source.mpl examples/*.mpl
```

`dump-languages` should include `scope: source.mpl`. The scope, `.mpl` file type, and highlight-query path are declared in [`tree-sitter.json`](tree-sitter.json). To leave the default configuration untouched, create a separate config with the same `parser-directories` entry and pass `--config-path /path/to/config.json` to both commands.

The older `tree-sitter highlight --grammar-path ...` command does not work with the project's 0.25 CLI because that flag is not available there.

## Neovim

### Manual source install

Keep the clone at a stable path. Build its committed parser source into Neovim's parser runtime directory inside the repository:

```sh
npm ci
mkdir -p parser
CC=cc npx tree-sitter build -o parser/mpl.so
```

Use `parser/mpl.dylib` instead on macOS. On Windows, omit the `CC=cc` environment assignment and output `parser/mpl.dll`. Parser generation is not required just to install it.

Add the repository to Neovim's runtime path, register the file type, and start the built-in Tree-sitter highlighter:

```lua
local mpl_root = "/absolute/path/to/tree-sitter-mpl"

vim.opt.runtimepath:prepend(mpl_root)
vim.filetype.add({
  extension = {
    mpl = "mpl",
  },
})

local group = vim.api.nvim_create_augroup("MplTreesitter", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "mpl",
  callback = function(args)
    vim.treesitter.start(args.buf, "mpl")
  end,
})
```

This layout exposes both `parser/mpl.*` and `queries/mpl/highlights.scm` on `runtimepath`. Restart Neovim, open an `.mpl` file, and verify that `:set filetype?` reports `mpl`.

### Prebuilt parsers

The rolling [`latest` release](https://github.com/scristobal/tree-sitter-mpl/releases/tag/latest) contains native parsers for Linux, macOS, and Windows on x64 and arm64, plus a WASM parser. It is updated from `main` after CI checks, tests, and all builds pass; it is not a versioned stable release.

For Neovim, download the matching native asset and rename it to `parser/mpl.so`, `parser/mpl.dylib`, or `parser/mpl.dll` under this clone. The runtime-path configuration above is still needed because the release asset contains the parser, while the highlight query remains in the repository.

## Development

Install exact dependencies and run the same grammar check and parser test commands used by CI:

```sh
npm ci
npm run check
npm test
```

`npm test` runs `tree-sitter test`: it checks parser cases in `test/corpus/` and any highlighting fixtures in `test/highlight/`.

For a highlighting change:

1. Edit `queries/mpl/highlights.scm`.
2. Add or update a focused `.mpl` fixture in `test/highlight/`, using Tree-sitter caret comments to assert the expected `@capture` names.
3. Run `npm test` for assertions, then use the highlighting command above for a visual smoke check.

After changing `grammar.js`, regenerate and review the committed files under `src/`:

```sh
npm run generate
git diff -- src
```

A native build is an optional additional smoke check on Linux or macOS:

```sh
CC=cc npx tree-sitter build
```

On Windows, run `npx tree-sitter build` instead. Do not commit native parser libraries; they are platform-dependent release artifacts.
