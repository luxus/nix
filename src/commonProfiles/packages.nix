{globals, ...}: {
  config,
  lib,
  pkgs,
  ...
}:
with builtins // lib; {
  environment.systemPackages =
    (with pkgs; [
      cachix
      clash-meta
      curl
      duf
      eza
      gh
      git
      helix
      nettools
      tmux
      vim
      wget
    ])
    ++ (optionals pkgs.stdenv.isLinux (with pkgs; [
      cloudflare-warp
    ]));

  programs.zsh.enable = true;
}
