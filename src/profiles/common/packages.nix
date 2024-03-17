# Basic packages for NixOS and Nix-darwin.
{globals, ...}: {
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
      alejandra
      curl
      duf
      eza
      fd
      fzf
      gdu
      gh
      git
      helix
      home-manager
      htop
      jq
      man
      neofetch
      nodejs_21
      nettools
      nvfetcher
      ripgrep
      rsync
      vim
      wget
      zellij
    ]
    ++ (lib.optionals pkgs.stdenv.isDarwin [
      globals.outputs.packages.${pkgs.system}.lporg
    ]);

  programs.fish.enable = false;
  programs.tmux.enable = false;
  programs.zsh.enable = true;
}
