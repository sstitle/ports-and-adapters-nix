let
  nuScript = import ../lib/nu-script.nix;
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
}
