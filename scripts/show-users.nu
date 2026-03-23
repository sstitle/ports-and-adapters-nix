#!/usr/bin/env nu

nix eval --json --file config/users.nix | from json | table
