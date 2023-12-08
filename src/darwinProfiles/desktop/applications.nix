{globals, ...}: {
  config,
  lib,
  pkgs,
  ...
}:
with builtins // lib; {
  homebrew.enable = true;

  # Upgrade and uninstall homebrew casks automatically.
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.upgrade = true;
  homebrew.onActivation.cleanup = "uninstall";
  homebrew.brews = [ "turso" "gnu-sed" ];
  # Add taps.
  homebrew.taps = [
    "buo/cask-upgrade"
    "homebrew/cask-fonts"
    "homebrew/cask-versions"
    "homebrew/cask"
    "homebrew/command-not-found"
    "homebrew/core"
    "homebrew/services"
    "tursodatabase/tap"
  ];

  # Add casks.
  homebrew.casks =
    pipe
    ''
    steam
    keycastr
    aldente
    espanso
    superslicer
    qlmarkdown
    microsoft-teams
    cloudflare-warp
    podman-desktop
    scroll-reverser
    raycast
    zoom
    logseq
    balenaetcher
    1password-beta
    plexamp
    utm
    obsidian
    gitkraken
    plex
    microsoft-edge-dev
    lunar
    visual-studio-code-insiders
    sf-symbols
    wireshark
    iina
    tidal
    wez/wezterm/wezterm-nightly
    microsoft-remote-desktop
    raycast
    telegram
    warp
    ''
    [
      (splitString "\n")
      (filter (s: s != ""))
    ];

  environment.systemPath =
    if pkgs.system == "aarch64-darwin"
    then [
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
    ]
    else [];
}
