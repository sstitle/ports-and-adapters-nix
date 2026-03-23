let
  user = import ../lib/user.nix;
in
[
  (user.mkUser {
    name = "test_user";
    password = "test_password";
  })
]
