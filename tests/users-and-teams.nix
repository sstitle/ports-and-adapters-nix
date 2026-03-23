let
  userRepository = import ../examples/users-and-teams/lib/user-repository.nix;
  teamRepository = import ../examples/users-and-teams/lib/team-repository.nix;
  users = import ../examples/users-and-teams/config/users.nix;
  teams = import ../examples/users-and-teams/config/teams.nix;
in
{
  "test mkUserRepository get returns a user" = {
    expr = (userRepository.mkUserRepository {
      alice = { name = "Alice"; role = "admin"; };
    }).get "alice";
    expected = { name = "Alice"; role = "admin"; };
  };

  "test mkUserRepository register returns a user repository" = {
    expr =
      let
        repo = userRepository.mkUserRepository { };
        updated = repo.register "bob" { name = "Bob"; role = "user"; };
      in
      updated.get "bob";
    expected = { name = "Bob"; role = "user"; };
  };

  "test mkUserRepository register preserves existing entries" = {
    expr =
      let
        repo = userRepository.mkUserRepository {
          alice = { name = "Alice"; role = "admin"; };
        };
        updated = repo.register "bob" { name = "Bob"; role = "user"; };
      in
      updated.names;
    expected = [ "alice" "bob" ];
  };

  "test mkTeamRepository get returns a team" = {
    expr = (teamRepository.mkTeamRepository {
      engineering = { name = "Engineering"; members = [ "alice" "bob" ]; };
    }).get "engineering";
    expected = { name = "Engineering"; members = [ "alice" "bob" ]; };
  };

  "test mkTeamRepository register returns a team repository" = {
    expr =
      let
        repo = teamRepository.mkTeamRepository { };
        updated = repo.register "design" { name = "Design"; members = [ "carol" ]; };
      in
      updated.get "design";
    expected = { name = "Design"; members = [ "carol" ]; };
  };

  "test mkTeamRepository is distinct from mkUserRepository" = {
    expr =
      let
        ur = userRepository.mkUserRepository { alice = { name = "Alice"; role = "admin"; }; };
        tr = teamRepository.mkTeamRepository { eng = { name = "Engineering"; members = [ "alice" ]; }; };
      in
      ur.names != tr.names;
    expected = true;
  };

  "test users config has all users" = {
    expr = users.names;
    expected = [ "alice" "bob" "carol" "dave" ];
  };

  "test users config alice is admin" = {
    expr = (users.get "alice").role;
    expected = "admin";
  };

  "test users config bob is on engineering team" = {
    expr = (users.get "bob").team;
    expected = "engineering";
  };

  "test teams config has all teams" = {
    expr = teams.names;
    expected = [ "design" "engineering" ];
  };

  "test teams config engineering lead is alice" = {
    expr = (teams.get "engineering").lead;
    expected = "alice";
  };

  "test teams config design has correct members" = {
    expr = (teams.get "design").members;
    expected = [ "carol" "dave" ];
  };
}
