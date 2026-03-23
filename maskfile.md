# Maskfile

This is a [mask](https://github.com/jacobdeichert/mask) task runner file.

## test

> Run all nix-unit tests

```bash
nix run github:nix-community/nix-unit -- ./tests/default.nix
```

## run

> Display all configured users as a table

```bash
nu scripts/show-users.nu
```

## docs

> Build and display the library documentation in a browser

```bash
nix build .#docs
html=$(mktemp /tmp/docs-XXXXXX.html)
pandoc result --standalone --metadata title="ports-and-adapters-nix" -o "$html"
open "$html"
```

## hello

> This is an example command you can run with `mask hello`

```bash
echo "Hello World!"
```
