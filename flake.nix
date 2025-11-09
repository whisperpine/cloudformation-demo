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
          system:
          f {
            pkgs = import inputs.nixpkgs { inherit system; };
            pkgs-stable = import inputs.nixpkgs-stable { inherit system; };
          }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs, pkgs-stable }:
        {
          default = pkgs.mkShell {
            # The Nix packages installed in the dev environment.
            packages = with pkgs; [
              just # just a command runner
              cocogitto # conventional commit toolkit
              sops # simple tool for managing secrets
              husky # managing git hooks
              typos # check misspelling
              awscli2 # aws command line tool
            ];
            # The shell script executed when the environment is activated.
            shellHook = ''
              # Print the last modified date of "flake.lock".
              stat flake.lock | grep "Modify" |
                awk '{printf "\"flake.lock\" last modified on: %s", $2}' &&
                echo " ($((($(date +%s) - $(stat -c %Y flake.lock)) / 86400)) days ago)"
              # Install git hooks managed by husky.
              if [ ! -e "./.husky/_" ]; then husky install; fi
            '';
          };
        }
      );
    };
}
