# Maskfile

This is a [mask](https://github.com/jacobdeichert/mask) task runner file.

## test

> Run all nix-unit tests

```bash
nix run github:nix-community/nix-unit -- --flake '.#tests'
```

## run

> Display port configuration as a table

```bash
nix run .#show-ports
```

## hello

> This is an example command you can run with `mask hello`

```bash
echo "Hello World!"
```
