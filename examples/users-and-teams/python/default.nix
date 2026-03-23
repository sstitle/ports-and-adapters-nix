{ pkgs, domain, repositories }:
let
  protoPkg = import ../../../lib/proto-pkg.nix { inherit pkgs; };
  repoService = import ../../../lib/mk-repository-service.nix { inherit pkgs; };

  protoStubs = pkgs.runCommand "users-and-teams-proto-stubs" { } ''
    mkdir $out
    ${builtins.concatStringsSep "\n" (
      map (
        key:
        let
          entity = domain.get key;
          serviceProto = repoService.mkRepositoryServiceProto {
            inherit key;
            entityName = entity.name;
          };
          stubs = protoPkg.mkProtoPkg {
            name = key;
            protos = [
              entity.proto
              serviceProto
            ];
          };
        in
        "cp ${stubs}/* $out/"
      ) domain.names
    )}
  '';

  generatedRepos = pkgs.runCommand "users-and-teams-generated-repos" { } ''
    mkdir $out
    ${builtins.concatStringsSep "\n" (
      map (
        key:
        let
          entity = domain.get key;
          repoFile = repoService.mkInMemoryRepositoryPy {
            inherit key;
            entityName = entity.name;
          };
          servicerFile = repoService.mkGrpcServicerPy {
            inherit key;
            entityName = entity.name;
          };
        in
        ''
          cp ${repoFile} $out/${repoFile.name}
          cp ${servicerFile} $out/${servicerFile.name}
        ''
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
  ]);
in
pkgs.writeShellApplication {
  name = "show-repositories";
  runtimeInputs = [ pythonEnv ];
  text = ''
    PYTHONPATH="${protoStubs}:${generatedRepos}" \
    ${dataEnv} \
    python3 ${./main.py}
  '';
}
