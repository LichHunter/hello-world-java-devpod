{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system ;
          };
        in
        with pkgs;
        {
          devShells.default = mkShell {
            shellHook = ''
            alias ll='ls -al'
            alias emacs='~/.config/emacs/bin/doom run'
            PS1="flake-shell>> "
            '';
            buildInputs = [
              git
              emacs
              jdk21
              ripgrep
              fd
              maven
              python3
            ];
          };
        }
      );
}
