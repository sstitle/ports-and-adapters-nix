let
  registry = import ./registry.nix;
  mkRepository = entries: registry.mkRegistryWith mkRepository entries;
in
{
  inherit mkRepository;
}
