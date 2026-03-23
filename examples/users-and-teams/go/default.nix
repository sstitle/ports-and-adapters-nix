{ pkgs, domain, repositories }:
let
  protoPkgGo = import ../../../lib/proto-pkg-go.nix { inherit pkgs; };
  repoService = import ../../../lib/mk-repository-service.nix { inherit pkgs; };

  protoStubs = pkgs.runCommand "users-and-teams-proto-stubs-go" { } ''
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
          stubs = protoPkgGo.mkProtoPkgGo {
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

  goBin = pkgs.buildGoModule {
    pname = "show-repositories-go";
    version = "0.1.0";
    src = pkgs.runCommand "go-src" { } ''
      mkdir -p $out
      cp ${./main.go} $out/main.go
      ${builtins.concatStringsSep "\n" (
        map (
          key:
          let
            entity = domain.get key;
            repoFile = repoService.mkInMemoryRepositoryGo {
              inherit key;
              entityName = entity.name;
            };
          in
          "cp ${repoFile} $out/${repoFile.name}"
        ) domain.names
      )}
      cat > $out/go.mod <<'EOF'
module show-repositories-go

go 1.21
EOF
    '';
    # protoStubs validates the service proto compiles; the binary itself is stdlib-only
    nativeBuildInputs = [ protoStubs ];
    vendorHash = null;
  };
in
pkgs.writeShellApplication {
  name = "show-repositories-go";
  runtimeInputs = [ goBin ];
  text = ''
    ${dataEnv} \
    show-repositories-go
  '';
}
