{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.hostName = "emily";
  networking.computerName = "Kais MacBook Pro";

  users.users.luxus = {
    name = "luxus";
    home = "/Users/luxus";
  };
}
