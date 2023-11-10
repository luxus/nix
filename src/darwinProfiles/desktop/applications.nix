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

  # Add taps.
  homebrew.taps = [
    "buo/cask-upgrade"
    "homebrew/cask-fonts"
    "homebrew/cask-versions"
    "homebrew/cask"
    "homebrew/command-not-found"
    "homebrew/core"
    "homebrew/services"
  ];

  # Add casks.
  homebrew.casks =
    pipe
    ''
      1password
      1password-cli
      adobe-creative-cloud
      adrive
      alt-tab
      amethyst
      applite
      arc
      baidunetdisk
      balenaetcher
      bilibili
      clashx
      cloudflare-warp
      cursor
      cyberduck
      discord
      element
      feishu
      fig
      firefox
      github
      google-chrome
      google-drive
      hiddenbar
      iina
      itsycal
      jetbrains-toolbox
      keepingyouawake
      keka
      kitty
      logitech-options
      maccy
      macfuse
      microsoft-auto-update
      microsoft-office
      microsoft-remote-desktop
      miniforge
      monitorcontrol
      mos
      motrix
      mounty
      neteasemusic
      notion
      obs
      obsidian
      onyx
      orbstack
      qfinder-pro
      qq
      qsync-client
      qudedup-extract-tool
      raycast
      rectangle
      sioyek
      spotify
      squirrel
      stats
      steam
      surge4
      tailscale
      telegram
      tencent-lemon
      tencent-meeting
      transmission
      utm
      virtualbox
      visual-studio-code
      warp
      wechat
      wezterm
      xpra
      xquartz
      zed
      zotero
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
