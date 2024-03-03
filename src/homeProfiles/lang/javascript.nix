
{global, ...}: {
  config,
  lib,
  pkgs,
  ...
}:
with builtins // lib; {
  home.packages = with pkgs; [
  nodejs_21
  corepack_21
  ];
}
