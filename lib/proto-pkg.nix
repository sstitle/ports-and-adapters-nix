{ pkgs }:
{
  mkProtoPkg =
    { name, proto }:
    pkgs.runCommand "${name}-proto-py" {
      nativeBuildInputs = [ (pkgs.python3.withPackages (ps: [ ps.grpcio-tools ])) ];
    } ''
      mkdir -p $out proto_src
      cp ${proto} proto_src/${builtins.baseNameOf proto}
      python3 -m grpc_tools.protoc \
        -I proto_src \
        --python_out=$out \
        --grpc_python_out=$out \
        ${builtins.baseNameOf proto}
    '';
}
