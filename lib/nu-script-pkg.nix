{ pkgs }:
{
  toPackage =
    script:
    let
      nuFile = pkgs.writeText "${script.name}.nu" script.text;
      syntaxCheck = pkgs.runCommand "${script.name}-syntax-check" {
        nativeBuildInputs = [ pkgs.nushell ];
      } ''
        diagnostics=$(nu --no-config-file --ide-check 100 ${nuFile})
        if echo "$diagnostics" | grep -q '"severity":"Error"'; then
          echo "Nushell syntax errors in ${script.name}.nu:"
          echo "$diagnostics"
          exit 1
        fi
        cp ${nuFile} $out
      '';
      pkg = pkgs.writeShellApplication {
        name = script.name;
        runtimeInputs = [ pkgs.nushell ];
        text = "exec ${pkgs.nushell}/bin/nu ${syntaxCheck}";
      };
    in
    pkg // { inherit syntaxCheck; };
}
