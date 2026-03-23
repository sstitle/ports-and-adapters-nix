let
  nuScript = import ../../lib/nu-script.nix;
  users = import ./config/users.nix;
  teams = import ./config/teams.nix;
  domain = import ./domain-entities;
  usersJson = builtins.toJSON (builtins.attrValues users.entries);
  teamsJson = builtins.toJSON (builtins.attrValues teams.entries);
  domainEntitiesJson = builtins.toJSON (
    map (key: { inherit key; name = (domain.get key).name; }) domain.names
  );
  entitySection =
    key:
    let
      entity = domain.get key;
    in
    ''
      print ""
      print "=== ${entity.name} ==="
      print '${builtins.readFile entity.proto}'
    '';
  entitySections = builtins.concatStringsSep "\n" (map entitySection domain.names);
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
      print "Domain Entities:"
      '${domainEntitiesJson}' | from json | table | print
      ${entitySections}
      print ""
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
