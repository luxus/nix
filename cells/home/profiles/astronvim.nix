{ globals, ... }:
{ config
, lib
, inputs
, pkgs
, ...
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

    # package = pkgs.neovim;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
  };

  home = {
    sessionVariables = {
      #   EDITOR = "nvim";
      VISUAL = "nvim";
    };
    packages = with pkgs; [
      jdk22
      go
      vale
      luajitPackages.tiktoken_core
      luajitPackages.luarocks
      gdu
      libgit2
      nodejs_22
      python3
      vale
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
