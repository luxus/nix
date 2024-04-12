{ inputs, cell }:
let
  inherit (inputs) std nixpkgs;
in
{
  treefmt = std.lib.dev.mkNixago std.lib.cfg.treefmt {
    data = {
      global.excludes = [ "nvfetcher/generated.*" ];
      formatter = {
        nix = {
          command = "nixfmt";
          includes = [ "*.nix" ];
        };
        prettier = {
          command = "prettier";
          includes = [
            "*.json"
            "*.md"
            "*.yaml"
          ];
        };
      };
    };

    packages = [
      inputs.nixpkgs.nixfmt-rfc-style
      inputs.nixpkgs.nodePackages.prettier
    ];
  };
}
