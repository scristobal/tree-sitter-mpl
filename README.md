# tree-sitter-mpl

Tree-sitter grammar and highlighting queries for the [Axiom Metrics Processing Language (MPL)](https://axiom.co/docs/mpl).

## Neovim

Requires Neovim 0.12+, Tree-sitter CLI 0.26.1+, and a C compiler.

### Install with nvim-treesitter

Users of the [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter) `main` branch can register this repository as a custom language.

```lua
vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    require("nvim-treesitter.parsers").mpl = {
      install_info = {
        url = "https://github.com/scristobal/tree-sitter-mpl",
        queries = "queries/neovim",
      },
    }
  end,
})
```

Install the parser and query with:

```vim
:TSInstall mpl
```

### Build from source

If `nvim-treesitter` is not available, build and install the parser and highlighting query from source.

From the repository root on Linux:

```sh
npm ci
site="$HOME/.local/share/nvim/site"
mkdir -p "$site/parser" "$site/queries/mpl"
CC=cc npx tree-sitter build -o "$site/parser/mpl.so"
cp queries/neovim/highlights.scm "$site/queries/mpl/highlights.scm"
```

On macOS:

```sh
npm ci
site="$HOME/.local/share/nvim/site"
mkdir -p "$site/parser" "$site/queries/mpl"
CC=cc npx tree-sitter build -o "$site/parser/mpl.dylib"
cp queries/neovim/highlights.scm "$site/queries/mpl/highlights.scm"
```

On Windows, using PowerShell:

```powershell
npm ci
$site = Join-Path $env:LOCALAPPDATA "nvim-data\site"
New-Item -ItemType Directory -Force -Path "$site\parser", "$site\queries\mpl" | Out-Null
npx tree-sitter build -o "$site\parser\mpl.dll"
Copy-Item queries\neovim\highlights.scm "$site\queries\mpl\highlights.scm"
```

### Configuration

Regardless of whether MPL was installed with `nvim-treesitter` or manually, add this to `init.lua` to detect `.mpl` files and start Tree-sitter highlighting:

```lua
vim.filetype.add({ extension = { mpl = "mpl" } })

local group = vim.api.nvim_create_augroup("MplTreesitter", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "mpl",
  callback = function(args)
    vim.treesitter.start(args.buf, "mpl")
  end,
})
```

Restart Neovim and open an `.mpl` file. `:set filetype?` should report `mpl`.

## Helix

Add MPL to the Helix language configuration for your platform:

```toml
[[language]]
name = "mpl"
scope = "source.mpl"
file-types = ["mpl"]
comment-tokens = ["//"]
grammar = "mpl"

[[grammar]]
name = "mpl"
source = { git = "https://github.com/scristobal/tree-sitter-mpl", rev = "main" }
```

Fetch and build the grammar:

```sh
hx --grammar fetch
hx --grammar build
```

From the repository root on Linux and macOS:

```sh
query_dir="$HOME/.config/helix/runtime/queries/mpl"
mkdir -p "$query_dir"
cp queries/helix/highlights.scm "$query_dir/highlights.scm"
```

On Windows, using PowerShell from the repository root:

```powershell
$queryDir = Join-Path $env:APPDATA "helix\runtime\queries\mpl"
New-Item -ItemType Directory -Force -Path $queryDir | Out-Null
Copy-Item queries\helix\highlights.scm "$queryDir\highlights.scm"
```

Restart Helix and run `hx --health mpl` to verify the grammar and highlighting query.

## Development

Development requires Node.js/npm and a C compiler.

```sh
npm ci
npm run check
npm test
```

`npm test` runs the parser corpus and Tree-sitter CLI highlighting fixtures. Neovim and Helix fixtures require Neovim and Rust/Git, respectively:

```sh
npm run test:neovim
npm run test:helix
```

Highlighting changes should update each query and its fixtures under `test/highlight/` and `test/editors/`.

After changing `grammar.js`, regenerate the committed parser sources:

```sh
npm run generate
git diff -- src
```

Generated parser sources are committed so make sure include those in the next commit.
