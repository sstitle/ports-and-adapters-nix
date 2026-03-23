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

## show-repositories

> Display UserRepository and TeamRepository contents via Python and Pydantic

```bash
nix run .#show-repositories
```

## show-repositories-go

> Display UserRepository and TeamRepository contents via Go

```bash
nix run .#show-repositories-go
```

## hello

> This is an example command you can run with `mask hello`

```bash
echo "Hello World!"
```
