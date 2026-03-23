let
  repository = import ../../../lib/repository.nix;
in
repository.mkRepository {
  user = import ./user;
  team = import ./team;
}
