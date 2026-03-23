{ pkgs, domain, repositories }:
let
  protoPkgGo = import ../../../lib/proto-pkg-go.nix { inherit pkgs; };

  protoStubs = pkgs.runCommand "users-and-teams-proto-stubs-go" { } ''
    mkdir $out
    ${builtins.concatStringsSep "\n" (
      map (
        key: "cp ${protoPkgGo.mkProtoPkgGo { name = key; proto = (domain.get key).proto; }}/* $out/"
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
      cp ${./repositories.go} $out/repositories.go
      cat > $out/go.mod <<'EOF'
module show-repositories-go

go 1.21
EOF
    '';
    # protoStubs is a build-time validation that the .go files compile;
    # the binary itself uses only stdlib so no vendor hash is needed
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
