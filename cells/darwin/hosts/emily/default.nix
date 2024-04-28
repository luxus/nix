{ inputs, cell }:
{
  _module.specialArgs = {
    inherit inputs;
  };

  imports = [
    ./applications.nix
    ./configuration.nix
    # inputs.catppuccin.nixosModules.catppuccin

    inputs.cells.darwin.darwinProfiles.core
    inputs.cells.darwin.darwinProfiles.homebrew
    inputs.cells.darwin.darwinProfiles.desktop

    inputs.cells.home.homeProfiles.base

    {
      home-manager.users.luxus = {
        imports = [
          # inputs.cells.home.homeProfiles.catppuccin
          inputs.cells.home.homeProfiles.core
          inputs.cells.home.homeProfiles.languages
          inputs.cells.home.homeProfiles.shell
          inputs.cells.home.homeProfiles.aerospace
          inputs.cells.home.homeProfiles.wezterm
          inputs.cells.home.homeProfiles.ghostty
          inputs.cells.home.homeProfiles.astronvim
          inputs.cells.home.homeProfiles.kitty
          inputs.cells.home.homeProfiles.redteam
          # inputs.cells.home.homeProfiles.ssh
          inputs.catppuccin.homeManagerModules.catppuccin
        ];

        bee.home-languages = [
          # "c"
          # "latex"
          "nix"
          # "python"
          # "rust"
        ];

        catppuccin.flavour = "mocha";
      };
    }
  ];
  bee = rec {
    system = "aarch64-darwin";
    darwin = inputs.darwin;
    home = inputs.home-manager;
    pkgs = import inputs.nixpkgs-darwin {
      inherit system;
      config = {
        allowUnfree = true;
      };
      overlays = [
        inputs.agenix.overlays.default
        inputs.neovim-nightly-overlay.overlays.default
        inputs.devenv.overlays.default
        inputs.colmena.overlays.default
        inputs.fenix.overlays.default
        inputs.nvfetcher.overlays.default
      ];
    };
  };
}
