{ inputs, cell }:
{ pkgs, ... }:
{
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  environment.systemPackages = with pkgs; [
    _1password-gui
    clapper
    discord
    dolphin
    dragon
    google-chrome
    haruna
    # mpv
    steam
    vlc
    vscode
    zotero
  ];

  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    #FIX: just add fonts i need
    nerdfonts
  ];
}
