let
  repository = import ../../../lib/repository.nix;
in
repository.mkRepository {
  engineering = { name = "Engineering"; lead_id = "alice"; member_ids = [ "alice" "bob" ]; };
  design = { name = "Design"; lead_id = "carol"; member_ids = [ "carol" "dave" ]; };
}
