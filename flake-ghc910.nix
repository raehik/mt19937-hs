pkgs:

{
  # disable local project options (always do this for package sets)
  defaults.packages = {};
  devShell.enable = false;
  autoWire = [];


  basePackages = pkgs.haskell.packages.ghc910;

  packages = {
    # nixpkgs has these but versioned due to not preferring GHC 9.10
    # (not doing the nixpkgs syntax because it's clumsy, this works as well)
    primitive.source = "0.9.0.0";

    # ok these ones are only relevant for devshell, which isn't working due to
    # cabal-install. so let's ignore them for now
    #indexed-traversable.source = "0.1.4";
    #tar.source = "0.6.2.0";
    #zlib.source = "0.7.1.0";
    #hackage-security.source = "0.6.2.6";
  };

  settings = {
    # tests: dependency loop via hspec ->tf-random -> primitive
    primitive.check = false;

    # tests: clumsy, asserts module name as `main` which changes in our build
    call-stack.check = false;

    # tests: 0.22.2 has a bug for GHC 9.10. ignore until we upgrade
    doctest.check = false;
  };

}
