let
  domainEntity = import ../../../../lib/domain-entity.nix;
in
domainEntity.mkDomainEntity {
  name = "User";
  proto = ./user.proto;
}
