{globals, ...}: {
  config,
  lib,
  pkgs,
  ...
}:
with builtins // lib; {
  home.packages = with pkgs; [
    openssh
    ssh-copy-id
    sshfs
    sshping
  ];

  home.file.".ssh/config".text = ''
    Include config.d/home
    Include config.d/lab
  '';
  home.file.".ssh/config.d/home".source = globals.root + /static/configs/ssh/home;
  home.file.".ssh/config.d/lab".source = globals.root + /static/configs/ssh/lab;
}
