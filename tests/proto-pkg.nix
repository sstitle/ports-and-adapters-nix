{ pkgs }:
let
  protoPkg = import ../lib/proto-pkg.nix { inherit pkgs; };
  domain = import ../examples/users-and-teams/domain-entities;
in
{
  "test mkProtoPkg produces a derivation" = {
    expr = builtins.isAttrs (protoPkg.mkProtoPkg {
      name = "user";
      protos = [ (domain.get "user").proto ];
    });
    expected = true;
  };

  "test mkProtoPkg derivation has correct name" = {
    expr = (protoPkg.mkProtoPkg {
      name = "user";
      protos = [ (domain.get "user").proto ];
    }).name;
    expected = "user-proto-py";
  };
}
