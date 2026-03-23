let
  repository = import ../../../lib/repository.nix;
in
repository.mkRepository {
  engineering = { name = "Engineering"; lead = "alice"; members = [ "alice" "bob" ]; };
  design = { name = "Design"; lead = "carol"; members = [ "carol" "dave" ]; };
}
