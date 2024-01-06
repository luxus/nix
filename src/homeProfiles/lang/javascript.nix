
{global, ...}: {
  config,
  lib,
  pkgs,
  ...
}:
with builtins // lib; {
  home.packages = with pkgs; [
  bun
  supabase-cli
  nodejs_21
  corepack_21
  ];
}
