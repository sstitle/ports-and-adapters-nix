let
  registry = import ./registry.nix;
  mkDomainEntityRegistry = entries: registry.mkRegistryWith mkDomainEntityRegistry entries;
in
{
  inherit mkDomainEntityRegistry;
}
