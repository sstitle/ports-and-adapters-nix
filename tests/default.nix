{ pkgs ? null, ... }:
let
  nuScript = import ../lib/nu-script.nix;
  nuScriptPkg = if pkgs != null then import ../lib/nu-script-pkg.nix { inherit pkgs; } else null;
in
{
  "test mkNuScript has a name" = {
    expr = (nuScript.mkNuScript {
      name = "hello";
      script = "print 'Hello'";
    }).name;
    expected = "hello";
  };

  "test mkNuScript text has nu shebang" = {
    expr =
      let
        result = nuScript.mkNuScript {
          name = "hello";
          script = "print 'Hello'";
        };
      in
      builtins.substring 0 18 result.text;
    expected = "#!/usr/bin/env nu\n";
  };

  "test mkNuScript text contains the script content" = {
    expr =
      let
        result = nuScript.mkNuScript {
          name = "hello";
          script = "print 'Hello'";
        };
      in
      builtins.match ".*print 'Hello'.*" result.text != null;
    expected = true;
  };
} // (if nuScriptPkg != null then {
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
} else { })
