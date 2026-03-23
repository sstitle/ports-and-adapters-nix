let
  teamRepository = import ../lib/team-repository.nix;
in
teamRepository.mkTeamRepository {
  engineering = { name = "Engineering"; lead = "alice"; members = [ "alice" "bob" ]; };
  design = { name = "Design"; lead = "carol"; members = [ "carol" "dave" ]; };
}
