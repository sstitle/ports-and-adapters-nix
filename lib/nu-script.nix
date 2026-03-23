{
  mkNuScript =
    { name, script }:
    {
      inherit name;
      text = ''
        #!/usr/bin/env nu
        ${script}
      '';
    };
}
