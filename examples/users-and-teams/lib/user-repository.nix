let
  registry = import ../../../lib/registry.nix;
  mkUserRepository = entries: registry.mkRegistryWith mkUserRepository entries;
in
{
  inherit mkUserRepository;
}
