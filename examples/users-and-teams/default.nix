{ pkgs }:
let
  nuScriptPkg = import ../../lib/nu-script-pkg.nix { inherit pkgs; };
  scripts = import ./scripts.nix;
  showRepositories = import ./python { inherit pkgs; };
  mkApp = pkg: { type = "app"; program = "${pkg}/bin/${pkg.name}"; };
  nuPackages = builtins.mapAttrs (_: nuScriptPkg.toPackage) scripts;
  nuApps = builtins.mapAttrs (_: mkApp) nuPackages;
in
{
  packages = nuPackages // { show-repositories = showRepositories; };
  apps = nuApps // { show-repositories = mkApp showRepositories; };
}
