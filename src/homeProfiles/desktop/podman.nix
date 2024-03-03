{globals, ...}: {
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
  # podman-desktop
  podman-tui
  podman
  qemu
  ];
}
