{
  description = "A Nix-flake-based development environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system: f { pkgs = import inputs.nixpkgs { inherit system; }; }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            # The Nix packages installed in the dev environment.
            packages = with pkgs; [
              just # just a command runner
              cocogitto # conventional commit toolkit
              husky # managing git hooks
              typos # check misspelling
            ];
            # The shell script executed when the environment is activated.
            shellHook = ''
              # install git hook managed by husky
              if [ ! -e "./.husky/_" ]; then husky install; fi
            '';
          };
        }
      );
    };
}
