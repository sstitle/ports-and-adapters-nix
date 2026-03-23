let
  mkRegistryWith =
    reconstruct: entries:
    {
      inherit entries;
      get = name: entries.${name};
      has = name: builtins.hasAttr name entries;
      names = builtins.attrNames entries;
      register = name: value: reconstruct (entries // { ${name} = value; });
    };
in
{
  inherit mkRegistryWith;
  mkRegistry = entries: mkRegistryWith (import ./registry.nix).mkRegistry entries;
}
