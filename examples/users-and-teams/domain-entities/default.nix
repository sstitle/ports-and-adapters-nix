let
  domainEntityRegistry = import ../../../lib/domain-entity-registry.nix;
in
domainEntityRegistry.mkDomainEntityRegistry {
  user = import ./user;
  team = import ./team;
}
