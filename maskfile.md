# Maskfile

This is a [mask](https://github.com/jacobdeichert/mask) task runner file.

## test

> Run all nix-unit tests

```bash
nix run github:nix-community/nix-unit -- --flake '.#tests'
```

## show-users

> Display all users as a table

```bash
nix run .#show-users
```

## show-teams

> Display all teams as a table

```bash
nix run .#show-teams
```

## show-all

> Display users and teams

```bash
nix run .#show-all
```

## hello

> This is an example command you can run with `mask hello`

```bash
echo "Hello World!"
```
