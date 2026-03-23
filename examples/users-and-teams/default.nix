{ pkgs }:
let
  nuScriptPkg = import ../../lib/nu-script-pkg.nix { inherit pkgs; };
  scripts = import ./scripts.nix;
  mkApp = pkg: { type = "app"; program = "${pkg}/bin/${pkg.name}"; };
  packages = builtins.mapAttrs (_: nuScriptPkg.toPackage) scripts;
  apps = builtins.mapAttrs (_: mkApp) packages;
in
{ inherit packages apps; }
