{ globals, ... }: { config
                  , lib
                  , pkgs
                  , ...
                  }:
with builtins // lib; {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
    brews = [ "gnu-sed" ];
    # Add taps.
    taps = [
      "buo/cask-upgrade"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/cask"
      "homebrew/command-not-found"
      "homebrew/core"
      "homebrew/services"
      # "libsql/sqld"
      # "tursodatabase/tap"
    ];

    # Add casks.
    casks =
      pipe
        ''
          whisky
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
  };
  environment.systemPath =
    if pkgs.system == "aarch64-darwin"
    then [
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
    ]
    else [ ];
}
