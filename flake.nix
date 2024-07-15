{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
  };
  outputs = inputs:
  let
    # simple devshell for non-dev compilers: really just want `cabal repl`
    nondevDevShell = compiler: {
      mkShellArgs.name = "${compiler}-mt19937";
      hoogle = false;
      tools = _: {
        hlint = null;
        haskell-language-server = null;
        ghcid = null;
      };
    };
  in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;
      imports = [ inputs.haskell-flake.flakeModule ];
      perSystem = { self', pkgs, config, ... }: {
        packages.default  = self'.packages.ghc910-mt19937;
        devShells.default = self'.devShells.ghc910;
        haskellProjects.ghc910-base = import ./flake-ghc910.nix pkgs;
        haskellProjects.ghc910 = {
          basePackages = config.haskellProjects.ghc910-base.outputs.finalPackages;
          devShell = {
            hoogle = false;
            tools = _: {
              # best disable them for new GHC 9.10
              hlint = null;
              haskell-language-server = null;
              ghcid = null;
            };
            mkShellArgs.name = "ghc910-mt19937";
          };
        };
        haskellProjects.ghc98 = {
          # shouldn't work, pkgs aren't up to date and mine aren't 9.8 ready
          basePackages = pkgs.haskell.packages.ghc98;
          devShell = nondevDevShell "ghc98";
        };
        haskellProjects.ghc96 = {
          basePackages = pkgs.haskell.packages.ghc96;
          devShell.mkShellArgs.name = "ghc96-mt19937";
          devShell.tools = _: {
            haskell-language-server = null; # 2024-03-06: broken
          };
        };
        haskellProjects.ghc94 = {
          basePackages = pkgs.haskell.packages.ghc94;
          devShell = nondevDevShell "ghc94";
        };
        haskellProjects.ghc92 = {
          basePackages = pkgs.haskell.packages.ghc92;
          devShell = nondevDevShell "ghc92";
        };
      };
    };
}
