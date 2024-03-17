# Configuration for emily, which is an m1p MacbookPro.
{ globals, ... }:
globals.inputs.darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  specialArgs = { inherit globals; };
  modules =
    [
      ./_applications.nix
      ./_configuration.nix

      globals.inputs.home-manager.darwinModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit globals; };
          users.luxus = {
            imports = with globals.outputs.homeProfiles; [
              base
              # lang.complete
              shell
              programs.wezterm
              programs.aerospace
              astronvim
              # ssh
            ];
          };
        };
      }
    ]
    ++ (with globals.outputs.commonProfiles; [
      nix
      packages
    ])
    ++ (with globals.outputs.darwinProfiles; [
      homebrew
      desktop
    ]);
}
