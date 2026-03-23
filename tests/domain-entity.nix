let
  domainEntity = import ../lib/domain-entity.nix;
  repository = import ../lib/repository.nix;
  domain = import ../examples/users-and-teams/domain-entities;
in
{
  "test mkDomainEntity has a name" = {
    expr = (domainEntity.mkDomainEntity {
      name = "User";
      proto = ../examples/users-and-teams/domain-entities/user/user.proto;
    }).name;
    expected = "User";
  };

  "test mkDomainEntity has a proto path" = {
    expr = builtins.typeOf (domainEntity.mkDomainEntity {
      name = "User";
      proto = ../examples/users-and-teams/domain-entities/user/user.proto;
    }).proto;
    expected = "path";
  };

  "test mkRepository with domain entities lists all names" = {
    expr = (repository.mkRepository {
      user = domainEntity.mkDomainEntity { name = "User"; proto = ../examples/users-and-teams/domain-entities/user/user.proto; };
      team = domainEntity.mkDomainEntity { name = "Team"; proto = ../examples/users-and-teams/domain-entities/team/team.proto; };
    }).names;
    expected = [ "team" "user" ];
  };

  "test mkRepository with domain entities register preserves entries" = {
    expr =
      let
        reg = repository.mkRepository { };
        updated = reg.register "user" (domainEntity.mkDomainEntity {
          name = "User";
          proto = ../examples/users-and-teams/domain-entities/user/user.proto;
        });
      in
      (updated.get "user").name;
    expected = "User";
  };

  "test domain entity registry has user and team" = {
    expr = domain.names;
    expected = [ "team" "user" ];
  };

  "test domain user entity name is User" = {
    expr = (domain.get "user").name;
    expected = "User";
  };

  "test domain team entity name is Team" = {
    expr = (domain.get "team").name;
    expected = "Team";
  };

  "test domain user proto defines User message" = {
    expr = builtins.match ".*message User \\{.*" (builtins.readFile (domain.get "user").proto) != null;
    expected = true;
  };

  "test domain team proto defines Team message" = {
    expr = builtins.match ".*message Team \\{.*" (builtins.readFile (domain.get "team").proto) != null;
    expected = true;
  };
}
