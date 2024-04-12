# .nixd.nix
{
  eval = {
    # Example target for writing a package.
    target = {
      args = [
        "--expr"
        "with import <nixpkgs> { }; callPackage ./cells/common/packages/ { }"
      ];
      installable = "";
    };
    # Force thunks
    depth = 10;
  };
  formatting.command = "nixfmt";
  options = {
    enable = true;
    target = {
      args = [ ];
      # Example installable for flake-parts, nixos, and home-manager

      installable = ".#homeConfigurations.emily.options";
    };
  };
}
