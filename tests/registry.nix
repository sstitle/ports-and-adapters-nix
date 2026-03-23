let
  registry = import ../lib/registry.nix;
in
{
  "test mkRegistry get returns an entry by name" = {
    expr = (registry.mkRegistry { greet = "hello"; }).get "greet";
    expected = "hello";
  };

  "test mkRegistry has returns true for existing entry" = {
    expr = (registry.mkRegistry { foo = 1; }).has "foo";
    expected = true;
  };

  "test mkRegistry has returns false for missing entry" = {
    expr = (registry.mkRegistry { foo = 1; }).has "bar";
    expected = false;
  };

  "test mkRegistry names lists all entries" = {
    expr = (registry.mkRegistry { foo = 1; bar = 2; }).names;
    expected = [ "bar" "foo" ];
  };

  "test mkRegistry register adds an entry" = {
    expr = ((registry.mkRegistry { }).register "x" 42).get "x";
    expected = 42;
  };

  "test mkRegistry register returns a registry" = {
    expr = ((registry.mkRegistry { }).register "x" 42).has "x";
    expected = true;
  };
}
