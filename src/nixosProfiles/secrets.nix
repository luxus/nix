{globals, ...}: {
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    globals.inputs.agenix.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    agenix
  ];
}
