{
  description = "Development environment with nickel and mask";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nix-unit.url = "github:nix-community/nix-unit";
    nix-unit.inputs.nixpkgs.follows = "nixpkgs";
    nix-unit.inputs.flake-parts.follows = "flake-parts";
    nixdoc.url = "github:nix-community/nixdoc";
    nixdoc.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.nix-unit.modules.flake.default
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        let
          treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        in
        {
          devShells.default = import ./shell.nix { inherit pkgs; };

          # for `nix fmt`
          formatter = treefmtEval.config.build.wrapper;

          # for `nix flake check`
          checks = {
            formatting = treefmtEval.config.build.check self;
          };

          packages.docs = pkgs.runCommand "user-lib-docs" {
            nativeBuildInputs = [ inputs'.nixdoc.packages.default ];
          } ''
            nixdoc \
              --file ${./lib/user.nix} \
              --category "user" \
              --description "User domain model functions" \
              > $out
          '';

          nix-unit.inputs = {
            inherit (inputs) nixpkgs flake-parts nix-unit;
          };
          nix-unit.tests = import ./tests { };
        };
    };
}
