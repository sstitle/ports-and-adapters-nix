let
  registry = import ../../../lib/registry.nix;
  mkTeamRepository = entries: registry.mkRegistryWith mkTeamRepository entries;
in
{
  inherit mkTeamRepository;
}
