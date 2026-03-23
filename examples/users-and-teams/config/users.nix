let
  repository = import ../../../lib/repository.nix;
in
repository.mkRepository {
  alice = { name = "Alice Smith"; role = "admin"; team_id = "engineering"; };
  bob = { name = "Bob Jones"; role = "developer"; team_id = "engineering"; };
  carol = { name = "Carol White"; role = "designer"; team_id = "design"; };
  dave = { name = "Dave Brown"; role = "developer"; team_id = "design"; };
}
