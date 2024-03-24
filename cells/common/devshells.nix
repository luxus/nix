# project. It solves the vital problem of, "works on my machine."
{
  inputs,
  cell,
}: {
  default = inputs.std.lib.dev.mkShell {
    name = "nichijou";

    imports = [
      inputs.std.std.devshellProfiles.default
    ];

    packages = [
      (inputs.nixpkgs.extend inputs.nvfetcher.overlays.default).nvfetcher
    ];

    nixago = [
      cell.configs.treefmt
    ];

    commands = [
      {
        name = "fetch";
        help = "Fetch latest sources with nvfetcher";
        command = "nvfetcher -o nvfetcher";
      }
      {
        name = "fmt";
        help = "Format code with treefmt";
        command = "treefmt";
      }
    ];
  };
}