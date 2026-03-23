{ pkgs, domain, users, teams }:
let
  protoPkg = import ../../../lib/proto-pkg.nix { inherit pkgs; };

  protoStubs = pkgs.runCommand "users-and-teams-proto-stubs" { } ''
    mkdir $out
    ${builtins.concatStringsSep "\n" (
      map (
        key: "cp ${protoPkg.mkProtoPkg { name = key; proto = (domain.get key).proto; }}/* $out/"
      ) domain.names
    )}
  '';

  usersData = pkgs.writeText "users.json" (
    builtins.toJSON (map (key: (users.get key) // { id = key; }) users.names)
  );

  teamsData = pkgs.writeText "teams.json" (
    builtins.toJSON (map (key: (teams.get key) // { id = key; }) teams.names)
  );

  pythonEnv = pkgs.python3.withPackages (ps: [
    ps.grpcio
    ps.protobuf
    ps.pydantic
  ]);
in
pkgs.writeShellApplication {
  name = "show-repositories";
  runtimeInputs = [ pythonEnv ];
  text = ''
    PYTHONPATH="${protoStubs}:${./.}" \
    USERS_DATA="${usersData}" \
    TEAMS_DATA="${teamsData}" \
    python3 ${./main.py}
  '';
}
