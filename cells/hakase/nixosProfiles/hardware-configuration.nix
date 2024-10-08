{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["vmd" "xhci_pci" "ahci" "nvme" "usbhid" "uas" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];
  boot.supportedFilesystems = ["bcachefs"];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d7bb32dc-4599-499c-913e-73660f0cf3c6";
    fsType = "bcachefs";
    options = ["noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5764-78C1";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/d1772975-d75b-4efa-aed1-3cb602761b56";}
    {device = "/dev/disk/by-uuid/9dc3e2ac-b63d-4dda-8b4c-7be566aa349a";}
  ];

  bcachefs."/mnt/data" = {
    devices = ["/dev/nvme0n1p3" "/dev/sda1" "/dev/sdb1"];
    options = ["noatime"];
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
