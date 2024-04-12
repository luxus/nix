{ globals, ... }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  sources = pkgs.callPackage (globals.root + /_sources/generated.nix) { };
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    package = pkgs.neovim-nightly;
  };

  home = {
    sessionVariables = {
    #   EDITOR = "nvim";
      VISUAL = "nvim";
    };
    packages = with pkgs; [
      go
      gdu
      libgit2
      nodejs_21
      python3
      ripgrep
      tree-sitter
      nixd
    ];
  };

  # xdg.configFile."nvim" = {
  #   source = sources.astronvim.src;
  #   recursive = true;
  # };

  # xdg.configFile."nvim/lua/user" = {
  #   source = globals.root + /static/configs/astronvim;
  #   recursive = true;
  # };
}
