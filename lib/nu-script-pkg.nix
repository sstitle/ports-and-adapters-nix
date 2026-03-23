{ pkgs }:
{
  toPackage =
    script:
    let
      nuFile = pkgs.writeText "${script.name}.nu" script.text;
    in
    pkgs.writeShellApplication {
      name = script.name;
      runtimeInputs = [ pkgs.nushell ];
      text = "exec ${pkgs.nushell}/bin/nu ${nuFile}";
    };
}
