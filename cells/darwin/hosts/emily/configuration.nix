{
  networking.hostName = "emily";
  networking.computerName = "luxus MacBookPro";

  users.users.luxus = {
    name = "luxus";
    home = "/Users/luxus";
  };

  services.activate-system.enable = true;
  services.nix-daemon.enable = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # System configurations
  system.defaults = {
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      NSWindowShouldDragOnGesture = true;
    };
    dock.show-recents = false;
    dock.tilesize = 48;
    finder = {
      QuitMenuItem = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    trackpad.Clicking = false;
    trackpad.TrackpadThreeFingerDrag = false;
  };
  # Used for backwards compatibilityebuild changelog
  system.stateVersion = 4;
}
