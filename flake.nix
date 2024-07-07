{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    emacs-overlay.url = "github:nix-community/emacs-overlay/master";
  };
  outputs = { self, nixpkgs, flake-utils, emacs-overlay }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlays = [ (import emacs-overlay) ];
          pkgs = import nixpkgs {
            inherit system overlays;
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
              ((emacsPackagesFor emacs-unstable).emacsWithPackages
                (epkgs: [
                  epkgs.vterm
                  epkgs.treesit-grammars.with-all-grammars
                ]))

              jdk21
              ripgrep
              fd
              maven
              python3
              cmake
              libvterm
            ];
          };
        }
      );
}
