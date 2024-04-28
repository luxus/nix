{ inputs
, ...
}:
{
  imports = [ inputs.ghostty.homeModules.default ];
  programs.ghostty = {
    enable = true;

    settings = {

      font-feature = [
        "zero"
        "calt"
        "liga"
        "ss01"
        "ss02"
        "ss03"
        "ss05"
        "ss18"
        "ss07"
        "ss08"
        "ss09"
        "ss11"
        "ss15"
        "ss16"
        "ss17"
      ];
      # background-opacity = 0.9;
      # confirm-close-surface = false;
      # copy-on-select = true;
      cursor-style = "bar";
      font-family = "MonoLisa";
      font-size = 14;
      # background-blur-radius = 4;
      # unfocused-split-opacity = 0.6;
      # minimum-contrast = 1.1;
      macos-non-native-fullscreen = true;
      macos-option-as-alt = true;
      # term = "xterm-kitty";
      # theme = "catppuccin-mocha";
      # window-decoration = false;
      # window-padding-x = terminal.padding;
      # window-padding-y = terminal.padding;
      # mouse-hide-while-typing = true;

      quit-after-last-window-closed = true;


      macos-titlebar-tabs = false;

      # window-padding-x = 15;
      # window-padding-y = 15;
    };

    keybindings = {
      "super+left" = "goto_split:left";
      "super+right" = "goto_split:right";
      "super+up" = "goto_split:top";
      "super+down" = "goto_split:bottom";

      "page_up" = "scroll_page_fractional:-0.5";
      "page_down" = "scroll_page_fractional:0.5";
    };
  };
}
