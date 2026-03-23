let
  domainEntity = import ../../../../lib/domain-entity.nix;
in
domainEntity.mkDomainEntity {
  name = "Team";
  proto = ./team.proto;
}
