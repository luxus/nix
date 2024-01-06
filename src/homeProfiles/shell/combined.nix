{globals, ...}: {
  config,
  lib,
  pkgs,
  ...
}:
with builtins // lib; {
  imports = with globals.outputs.homeProfiles.shell; [
    astronvim
    bash
    bat
    bottom
    btop
    eza
    fzf
    gh
    git
    gitui
    red
    helix
    atuin
    # mcfly
    nix-index
    nvfetcher
    ssh
    starship
    tmux
    zoxide
    zsh
  ];

  programs.htop.enable = true;
  programs.jq.enable = true;
  programs.lazygit.enable = true;
  programs.ripgrep.enable = true;
  programs.vim.enable = true;

  home.packages =
    (with pkgs; [
      _1password
      cachix
      clash-meta
      code-minimap
      curl
      du-dust
      duf
      fd
      fh
      gdu
      home-manager
      mc
      mosh
      neofetch
      nettools
      nodejs_21
      corepack_21
      rclone
      rsync
      statix
      thefuck
      unzip
      wget
      zip
    ])
    ++ (optionals pkgs.stdenv.isLinux (with pkgs; [
      cloudflare-warp
      nitch
    ]));

  home.sessionPath = [
    "/usr/local/bin"
  ];
}
