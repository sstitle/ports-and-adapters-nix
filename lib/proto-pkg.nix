{ pkgs }:
let
  # Source file paths have the filename as the last path component.
  # Derivation outputs have "hash-name" as the last component, so use .name instead.
  protoName = p: if builtins.isPath p then builtins.baseNameOf p else p.name;
in
{
  mkProtoPkg =
    { name, protos }:
    pkgs.runCommand "${name}-proto-py" {
      nativeBuildInputs = [ (pkgs.python3.withPackages (ps: [ ps.grpcio-tools ])) ];
    } ''
      mkdir -p $out proto_src
      ${builtins.concatStringsSep "\n" (map (p: "cp ${p} proto_src/${protoName p}") protos)}
      python3 -m grpc_tools.protoc \
        -I proto_src \
        --python_out=$out \
        --grpc_python_out=$out \
        ${builtins.concatStringsSep " " (map protoName protos)}
    '';
}
