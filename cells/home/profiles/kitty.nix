{
  programs.kitty = {
    enable = true;
    catppuccin.enable = true;
    font = {
      name = "Monolisa";
      size = 14.0;
    };
    settings = {
      hide_window_decorations = "titlebar-only";
      font_features = "MonoLisa + frac + zero + ss02 + ss04 + ss07 + ss08 + ss09 + ss18";
      macos_colorspace = "default";
      # macos_traditional_fullscreen = true;
      macos_quit_when_last_window_closed = true;
      background_opacity = "0.9";
      macos_option_as_alt = "left";
      cursor_stop_blinking_after = "15";
      enable_audio_bell = "no";
    };
    # theme = "Catppuccin-Mocha";
  };
}
