let
  repository = import ../../../lib/repository.nix;
in
repository.mkRepository {
  alice = { name = "Alice Smith"; role = "admin"; team = "engineering"; };
  bob = { name = "Bob Jones"; role = "developer"; team = "engineering"; };
  carol = { name = "Carol White"; role = "designer"; team = "design"; };
  dave = { name = "Dave Brown"; role = "developer"; team = "design"; };
}
