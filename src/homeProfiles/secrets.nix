{globals, ...}: {
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    globals.inputs.agenix.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    agenix
  ];
}
