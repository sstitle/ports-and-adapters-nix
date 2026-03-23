let
  repository = import ../lib/repository.nix;
  users = import ../examples/users-and-teams/config/users.nix;
  teams = import ../examples/users-and-teams/config/teams.nix;
in
{
  "test mkRepository get returns an entry" = {
    expr = (repository.mkRepository {
      alice = { name = "Alice"; role = "admin"; };
    }).get "alice";
    expected = { name = "Alice"; role = "admin"; };
  };

  "test mkRepository register returns a repository" = {
    expr =
      let
        repo = repository.mkRepository { };
        updated = repo.register "bob" { name = "Bob"; role = "user"; };
      in
      updated.get "bob";
    expected = { name = "Bob"; role = "user"; };
  };

  "test mkRepository register preserves existing entries" = {
    expr =
      let
        repo = repository.mkRepository {
          alice = { name = "Alice"; role = "admin"; };
        };
        updated = repo.register "bob" { name = "Bob"; role = "user"; };
      in
      updated.names;
    expected = [ "alice" "bob" ];
  };

  "test two repositories are independent" = {
    expr =
      let
        r1 = repository.mkRepository { alice = { name = "Alice"; }; };
        r2 = repository.mkRepository { eng = { name = "Engineering"; }; };
        r1updated = r1.register "extra" { name = "Extra"; };
      in
      r2.has "extra";
    expected = false;
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
