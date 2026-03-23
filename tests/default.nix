{ pkgs ? null, ... }:
  import ./registry.nix
  // import ./nu-script.nix
  // import ./users-and-teams.nix
  // import ./domain-entity.nix
  // (if pkgs != null then import ./nu-script-pkg.nix { inherit pkgs; } else { })
