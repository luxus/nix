{ globals, ... }: { config
                  , lib
                  , pkgs
                  , ...
                  }:
let
  sources = pkgs.callPackage (globals.root + /_sources/generated.nix) { };
in
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
  };

  home.packages = with pkgs; [
    bottom
    go
    gdu
    libgit2
    nodejs_21
    lazygit
    python3
    ripgrep
    tree-sitter
  ];

  # xdg.configFile."nvim" = {
  #   source = sources.astronvim.src;
  #   recursive = true;
  # };

  # xdg.configFile."nvim/lua/user" = {
  #   source = globals.root + /static/configs/astronvim;
  #   recursive = true;
  # };
}
