{globals, ...}: {
  config,
  lib,
  pkgs,
  ...
}:
with builtins // lib; {
  imports = [
    globals.inputs.hyprland.homeManagerModules.default
  ];

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.extraConfig = readFile (globals.root + /static/configs/hyprland/hyprland.conf);

  home.packages = with pkgs; [
    brightnessctl
    cliphist
    colord
    dolphin
    dunst
    ffmpegthumbnailer
    imagemagick
    kitty
    libsForQt5.qt5.qtwayland
    libsForQt5.qt5ct
    pamixer
    playerctl
    polkit-kde-agent
    qt6.qtwayland
    swaybg
    waybar
    wezterm
    wf-recorder
    wlogout
    wlsunset
    wofi
    xdg-desktop-portal-hyprland
    xdotool
  ];
}
