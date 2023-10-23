{globals, ...}: {
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    globals.inputs.sops.homeManagerModules.sops
  ];

  home.packages = with pkgs; [
    age
    sops-import-keys-hook
    sops-init-gpg-key
    sops-install-secrets
    ssh-to-pgp
  ];
}
