{ pkgs }:
let
  # Source file paths have the filename as the last path component.
  # Derivation outputs have "hash-name" as the last component, so use .name instead.
  protoName = p: if builtins.isPath p then builtins.baseNameOf p else p.name;
in
{
  mkProtoPkgGo =
    { name, protos }:
    pkgs.runCommand "${name}-proto-go" {
      nativeBuildInputs = [
        pkgs.protobuf
        pkgs.protoc-gen-go
        pkgs.protoc-gen-go-grpc
      ];
    } ''
      mkdir -p $out proto_src
      ${builtins.concatStringsSep "\n" (map (p: "cp ${p} proto_src/${protoName p}") protos)}
      protoc \
        -I proto_src \
        --go_out=$out \
        --go_opt=paths=source_relative \
        --go-grpc_out=$out \
        --go-grpc_opt=paths=source_relative \
        ${builtins.concatStringsSep " " (map protoName protos)}
    '';
}
