{globals, ...}: {
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    globals.inputs.arion.nixosModules.arion
  ];

  virtualisation = {
    arion.backend = "docker";
    docker.enable = true;
    podman.enable = true;
  };

  environment.systemPackages = with pkgs; [
    arion
    docker-client
  ];
}
