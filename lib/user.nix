{
  /**
  Creates a user record from name and password.

  # Type

  ```
  mkUser :: { name :: String, password :: String } -> { name :: String, password :: String }
  ```

  # Arguments

  name
  : The username

  password
  : The user's password

  # Example

  ```nix
  mkUser { name = "alice"; password = "secret"; }
  # => { name = "alice"; password = "secret"; }
  ```
  */
  mkUser =
    { name, password }:
    {
      inherit name password;
    };
}
