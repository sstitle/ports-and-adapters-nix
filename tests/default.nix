let
  user = import ../lib/user.nix;
in
{
  "test example" = {
    expr = 1 + 1;
    expected = 2;
  };

  "test mkUser has a name" = {
    expr = (user.mkUser {
      name = "test_user";
      password = "test_password";
    }).name;
    expected = "test_user";
  };

  "test mkUser has a password" = {
    expr = (user.mkUser {
      name = "test_user";
      password = "test_password";
    }).password;
    expected = "test_password";
  };
}
