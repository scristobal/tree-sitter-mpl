# tree-sitter-mpl

Tree-sitter grammar and queries for [Axiom Metrics Processing Language (MPL)](https://axiom.co/docs/mpl)

## Local development

requires [tree-sitter](https://tree-sitter.github.io/tree-sitter/) and optionally [NodeJS](https://nodejs.org)

try out on the examples

```sh
tree-sitter highlight --grammar-path . --scope source.mpl examples/*.mpl
```

check the grammar (requires nodejs)

```sh
npm i && npm run check

```

run the tests

```sh
tree-sitter test
```

build with

```sh
tree-sitter build
```

generate codegen with

```sh
tree-sitter generate 
```

it's common for tree-sitter grammars to commit the codegen so that clients do not need tree-sitter installed
