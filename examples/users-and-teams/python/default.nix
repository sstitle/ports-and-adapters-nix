{ pkgs, domain, repositories }:
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

  repoDataFiles = builtins.mapAttrs (
    name: repo:
    pkgs.writeText "${name}.json" (
      builtins.toJSON (map (key: (repo.get key) // { id = key; }) repo.names)
    )
  ) repositories;

  dataEnv = builtins.concatStringsSep " \\\n    " (
    pkgs.lib.mapAttrsToList (
      name: dataFile: ''${pkgs.lib.toUpper name}_DATA="${dataFile}"''
    ) repoDataFiles
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
    ${dataEnv} \
    python3 ${./main.py}
  '';
}
