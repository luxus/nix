{ globals, ... }:
{ config, lib, pkgs, ... }:
with builtins // lib; {
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    # delugia-code
    # iosevka
    (nerdfonts.override { fonts = [ "Monaspace" "VictorMono" "Hack" "JetBrainsMono" ]; })
  ];
}
