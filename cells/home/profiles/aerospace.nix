{ globals, ... }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  tomlFormat = pkgs.formats.toml { };
  gen = cfg: (tomlFormat.generate "aerospace.toml" cfg);
  # Function to generate workspace and move-node-to-workspace commands with capitalized key for letters
  makeCommands = prefix: key: commandTemplate: {
    "${prefix}-${lib.strings.toLower key}" = lib.replaceStrings [ "{key}" ] [ key ] commandTemplate;
  };
  # Manually specified list of letters, capitalized
  letters = map (x: lib.strings.toUpper x) (lib.strings.stringToCharacters "wtz");
  # letters = map (x: lib.strings.toUpper x) (lib.strings.stringToCharacters "bcdefgimnpqrtvwxyz");
  # Combining numbers and capitalized letters
  keys = [
    "1"
    "2"
    "3"
    "4"
  ];
in
{
  home = {
    file = {
      ".config/aerospace/aerospace.toml".source = gen {
        start-at-login = true;
        after-startup-command = [
          "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=0xffe1e3e4 inactive_color=0xff494d64 width=5.0"
        ];
        exec-on-workspace-change = [
          "/bin/bash"
          "-c"
          "${pkgs.sketchybar}/bin/sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
        ];
        on-window-detected = [
          {
            "if" = {
              app-id = "company.thebrowser.Browser";
            }; # mnemonics W - Web Browser
            run = "move-node-to-workspace W";
          }
        ];
        # on-window-detected = {
        #   app-id = "net.kovidgoyal.kitty";
        #   run = "move-node-to-workspace T"; # mnemonics T - Terminal
        # };
        gaps = {
          inner.horizontal = 10;
          inner.vertical = 10;
          outer = {
            left = 2;
            bottom = 2;
            top = 20;
            right = 2;
          };
        };
        mode = {
          main.binding =
            (lib.foldl' (
              acc: key:
              acc
              // (makeCommands "alt" key "workspace {key}")
              // (makeCommands "alt-shift" key "move-node-to-workspace {key}")
            ) { } keys)
            // {
              alt-enter = "exec-and-forget open -n ${pkgs.kitty}/Applications/kitty.app";
              cmd-h = [ ];
              # See: https://nikitabobko.github.io/AeroSpace/commands#layout
              alt-slash = "layout tiles horizontal vertical";
              alt-comma = "layout accordion horizontal vertical";
              # See: https://nikitabobko.github.io/AeroSpace/commands#focus
              alt-h = "focus left";
              alt-j = "focus down";
              alt-k = "focus up";
              alt-l = "focus right";
              # See: https://nikitabobko.github.io/AeroSpace/commands#move
              alt-shift-h = "move left";
              alt-shift-j = "move down";
              alt-shift-k = "move up";
              alt-shift-l = "move right";

              # See: https://nikitabobko.github.io/AeroSpace/commands#resize
              alt-shift-minus = "resize smart -50";
              alt-shift-equal = "resize smart +50";

              # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
              alt-tab = "workspace-back-and-forth";
              # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
              alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

              # See: https://nikitabobko.github.io/AeroSpace/commands#mode
              alt-shift-semicolon = "mode service";
              alt-shift-slash = "mode join";
            };
          service.binding = {
            r = [
              "flatten-workspace-tree"
              "mode main"
            ]; # reset layout
            #s = ['layout sticky tiling', 'mode main'] # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
            f = [
              "layout floating tiling"
              "mode main"
            ]; # Toggle between floating and tiling layout
            backspace = [
              "close-all-windows-but-current"
              "mode main"
            ];
            esc = [
              "reload-config"
              "mode main"
            ];
          };
          join.binding = {
            alt-shift-h = [
              "join-with left"
              "mode main"
            ];
            alt-shift-j = [
              "join-with down"
              "mode main"
            ];
            alt-shift-k = [
              "join-with up"
              "mode main"
            ];
            alt-shift-l = [
              "join-with right"
              "mode main"
            ];
            esc = [ "mode main" ];
          };
        };
      };
    };
    packages = with pkgs; [ jankyborders ];
  };
}
