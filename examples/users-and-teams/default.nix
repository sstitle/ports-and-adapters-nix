{ pkgs }:
let
  domain = import ./domain-entities;
  repositories = {
    users = import ./config/users.nix;
    teams = import ./config/teams.nix;
  };
  nuScriptPkg = import ../../lib/nu-script-pkg.nix { inherit pkgs; };
  scripts = import ./scripts.nix {
    inherit domain;
    inherit (repositories) users teams;
  };
  showRepositories = import ./python { inherit pkgs domain repositories; };
  showRepositoriesGo = import ./go { inherit pkgs domain repositories; };
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
