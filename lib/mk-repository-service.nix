{ pkgs }:
let
  render =
    name: templateFile: data:
    let
      dataFile = pkgs.writeText "${name}-data.json" (builtins.toJSON data);
    in
    pkgs.runCommand name {
      nativeBuildInputs = [ (pkgs.python3.withPackages (ps: [ ps.chevron ])) ];
    } ''
      python3 -c "
import chevron, json, sys
with open('${dataFile}') as d, open('${templateFile}') as t:
    sys.stdout.write(chevron.render(t.read(), json.load(d)))
" > $out
    '';
in
{
  mkRepositoryServiceProto =
    { key, entityName }:
    render "${key}_service.proto" ./templates/repository-service.proto.mustache {
      name = key;
      Name = entityName;
    };

  mkInMemoryRepositoryPy =
    { key, entityName }:
    render "${key}_repository.py" ./templates/in-memory-repository.py.mustache {
      name = key;
      Name = entityName;
    };

  mkGrpcServicerPy =
    { key, entityName }:
    render "${key}_servicer.py" ./templates/grpc-servicer.py.mustache {
      name = key;
      Name = entityName;
    };

  mkInMemoryRepositoryGo =
    { key, entityName }:
    render "${key}_repository.go" ./templates/in-memory-repository.go.mustache {
      name = key;
      Name = entityName;
    };
}
