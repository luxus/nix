{globals, ...}: {
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    globals.inputs.sops.nixosModules.sops
  ];

  environment.systemPackages = with pkgs; [
    age
    sops-import-keys-hook
    sops-init-gpg-key
    sops-install-secrets
    ssh-to-pgp
  ];
}
