{ globals, ... }: { config
                  , lib
                  , pkgs
                  , ...
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
    # nix-index
    # nvfetcher
    ssh
    starship
    tmux
    zoxide
    # zsh
    zsh4humans
  ];

  programs = {
    htop.enable = true;
    jq.enable = true;
    direnv.enable = true;
    lazygit.enable = true;
    ripgrep.enable = true;
    vim.enable = true;
  };
  home.packages =
    (with pkgs; [
      _1password
      cachix
      clash-meta
      nix-tree
      jujutsu
      wezterm
      code-minimap
      curl
      comma
      yazi
      du-dust
      duf
      fd
      fh
      nix-index
      devenv
      gdu
      home-manager
      mc
      mosh
      neofetch
      nettools
      rclone
      rsync
      statix
      thefuck
      unzip
      wget
      zip
      sqlite
      cht-sh
      turso-cli
    ])
    ++ (optionals pkgs.stdenv.isLinux (with pkgs; [
      cloudflare-warp
      nitch
    ]));

  home.sessionPath = [
    "/usr/local/bin"
  ];
}
