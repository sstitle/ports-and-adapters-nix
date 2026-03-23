{ pkgs }:
let
  nuScript = import ../lib/nu-script.nix;
  nuScriptPkg = import ../lib/nu-script-pkg.nix { inherit pkgs; };
in
{
  "test toPackage produces a derivation with the right name" = {
    expr = (nuScriptPkg.toPackage (nuScript.mkNuScript {
      name = "show-ports";
      script = "echo hi";
    })).name;
    expected = "show-ports";
  };

  "test toPackage produces a derivation" = {
    expr = builtins.isAttrs (nuScriptPkg.toPackage (nuScript.mkNuScript {
      name = "show-ports";
      script = "echo hi";
    }));
    expected = true;
  };

  "test toPackage exposes a syntaxCheck derivation" = {
    expr = builtins.isAttrs (nuScriptPkg.toPackage (nuScript.mkNuScript {
      name = "show-ports";
      script = "echo hi";
    })).syntaxCheck;
    expected = true;
  };
}
