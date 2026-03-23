{ pkgs }:
{
  mkProtoPkgGo =
    { name, proto }:
    pkgs.runCommand "${name}-proto-go" {
      nativeBuildInputs = [
        pkgs.protobuf
        pkgs.protoc-gen-go
        pkgs.protoc-gen-go-grpc
      ];
    } ''
      mkdir -p $out proto_src
      cp ${proto} proto_src/${builtins.baseNameOf proto}
      protoc \
        -I proto_src \
        --go_out=$out \
        --go_opt=paths=source_relative \
        --go-grpc_out=$out \
        --go-grpc_opt=paths=source_relative \
        ${builtins.baseNameOf proto}
    '';
}
