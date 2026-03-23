let
  nuScript = import ../../lib/nu-script.nix;
  users = import ./config/users.nix;
  teams = import ./config/teams.nix;
  usersJson = builtins.toJSON (builtins.attrValues users.entries);
  teamsJson = builtins.toJSON (builtins.attrValues teams.entries);
in
{
  show-users = nuScript.mkNuScript {
    name = "show-users";
    script = ''
      '${usersJson}' | from json | table
    '';
  };

  show-teams = nuScript.mkNuScript {
    name = "show-teams";
    script = ''
      '${teamsJson}'
      | from json
      | update members { $in | str join ", " }
      | table
    '';
  };

  show-all = nuScript.mkNuScript {
    name = "show-all";
    script = ''
      print "Users:"
      '${usersJson}' | from json | table | print
      print ""
      print "Teams:"
      '${teamsJson}'
      | from json
      | update members { $in | str join ", " }
      | table
    '';
  };
}
