{ pkgs }:
let
  protoPkgGo = import ../lib/proto-pkg-go.nix { inherit pkgs; };
  domain = import ../examples/users-and-teams/domain-entities;
in
{
  "test mkProtoPkgGo produces a derivation" = {
    expr = builtins.isAttrs (protoPkgGo.mkProtoPkgGo {
      name = "user";
      protos = [ (domain.get "user").proto ];
    });
    expected = true;
  };

  "test mkProtoPkgGo derivation has correct name" = {
    expr = (protoPkgGo.mkProtoPkgGo {
      name = "user";
      protos = [ (domain.get "user").proto ];
    }).name;
    expected = "user-proto-go";
  };
}
