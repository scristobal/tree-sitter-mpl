# tree-sitter-mpl

Tree-sitter grammar and queries for [Axiom Metrics Processing Language (MPL)](https://axiom.co/docs/mpl)

requires [tree-sitter](https://tree-sitter.github.io/tree-sitter/) and optionally [NodeJS](https://nodejs.org)

Try out on the examples

```sh
tree-sitter highlight --grammar-path . --scope source.mpl examples/*.mpl
```

## Neovim install from source 

1. Build the parser into parser/mpl.so:

```sh
mkdir -p parser
tree-sitter generate
tree-sitter build -o parser/mpl.so
```

2. Replace `<repo-root>` and add this to your Neovim config:

```lua
vim.opt.runtimepath:append("<repo-root>")

vim.filetype.add({
    extension = {
        mpl = "mpl",
    },
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "mpl",
    callback = function()
        vim.treesitter.start()
    end,
})
```

## Local development

1. check the grammar (requires nodejs)

```sh
npm i && npm run check

```

2. run the tests

```sh
tree-sitter test
```

3. generate codegen with

```sh
tree-sitter generate 
```

it's common for tree-sitter grammars to commit the codegen so that clients do not need tree-sitter installed

4. (optionally) build with

```sh
tree-sitter build
```

but do not commit the compiled libraries as they are platform dependent
