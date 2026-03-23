{ pkgs }:
let
  domain = import ./domain-entities;
  users = import ./config/users.nix;
  teams = import ./config/teams.nix;
  nuScriptPkg = import ../../lib/nu-script-pkg.nix { inherit pkgs; };
  scripts = import ./scripts.nix { inherit domain users teams; };
  showRepositories = import ./python { inherit pkgs domain users teams; };
  showRepositoriesGo = import ./go { inherit pkgs domain users teams; };
  mkApp = pkg: { type = "app"; program = "${pkg}/bin/${pkg.name}"; };
  nuPackages = builtins.mapAttrs (_: nuScriptPkg.toPackage) scripts;
  nuApps = builtins.mapAttrs (_: mkApp) nuPackages;
in
{
  packages = nuPackages // {
    show-repositories = showRepositories;
    show-repositories-go = showRepositoriesGo;
  };
  apps = nuApps // {
    show-repositories = mkApp showRepositories;
    show-repositories-go = mkApp showRepositoriesGo;
  };
}
