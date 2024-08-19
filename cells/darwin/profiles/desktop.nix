{ globals, ... }:
{ config
, lib
, pkgs
, ...
}:
let
  aerospace-sh =
    pkgs.writeShellScriptBin "aerospace.sh"
      # bash
      ''
        #!/usr/bin/env bash
        if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
          sketchybar --set $NAME background.drawing=on
        else
          sketchybar --set $NAME background.drawing=off
        fi
      '';
  tomlFormat = pkgs.formats.toml { };
  captureTitle = "org-capture";
  keycodes = import ./keycodes.nix;
in
# with builtins // lib;
{
  services.sketchybar = {
    enable = false;
    config =
      # bash
      ''
        #!/bin/sh
        ${pkgs.sketchybar}/bin/sketchybar --add event aerospace_workspace_change

          for sid in $(aerospace list-workspaces --all); do
              ${pkgs.sketchybar}/bin/sketchybar --add item space.$sid left \
                  --subscribe space.$sid aerospace_workspace_change \
                  --set space.$sid \
                  background.color=0x44ffffff \
                  background.corner_radius=5 \
                  background.height=20 \
                  background.drawing=off \
                  label="$sid" \
                  click_script="aerospace workspace $sid" \
                  script="${aerospace-sh}/bin/aerospace.sh $sid"
          done

            bar=(
              color=0xff24273a
              height=32
              sticky=on
              padding_left=7
              padding_right=7
            )

            default=(
              icon.drawing=off
              label.padding_left=4
              label.padding_right=4
              label.color=0xffcad3f5
            )

            ${pkgs.sketchybar}/bin/sketchybar \
              --bar "''${bar[@]}" \
              --default "''${default[@]}"

            ${pkgs.sketchybar}/bin/sketchybar \
              --add item space left \
              --set space script='${pkgs.sketchybar}/bin/sketchybar --set $NAME label="[$(echo "$INFO" | jq .[])]"'\
              --subscribe space space_change


            ${pkgs.sketchybar}/bin/sketchybar \
              --add item app_name left \
              --set app_name script='${pkgs.sketchybar}/bin/sketchybar --set $NAME label="$USER::$INFO"' \
              --subscribe app_name front_app_switched

            ${pkgs.sketchybar}/bin/sketchybar \
              --add item time right \
              --set time script='${pkgs.sketchybar}/bin/sketchybar --set $NAME label="$(date "+%H:%M")"' \
                         update_freq=30 \
              --subscribe time system_woke

            ${pkgs.sketchybar}/bin/sketchybar \
              --add item ip right \
              --set ip script='${pkgs.sketchybar}/bin/sketchybar --set $NAME label="/$(ipconfig getifaddr en0)/"'\
              --subscribe ip wifi_change

            ${pkgs.sketchybar}/bin/sketchybar --update
      '';
  };
  services.yabai.enable = false;
  services.yabai.package = pkgs.yabai;
  services.yabai.enableScriptingAddition = false;
  services.yabai.extraConfig = ''
    yabai -m config debug_output                  on
    yabai -m config mouse_follows_focus           off
    yabai -m config focus_follows_mouse           off
    yabai -m config window_placement              second_child
    yabai -m config window_topmost                off
    yabai -m config window_opacity                on
    yabai -m config window_opacity_duration       0.0
    yabai -m config window_shadow                 on
    yabai -m config window_border                 off
    yabai -m config active_window_opacity         1.0
    yabai -m config normal_window_opacity         0.85
    yabai -m config split_ratio                   0.62
    yabai -m config auto_balance                  off

    yabai -m config layout                        bsp
    yabai -m config top_padding                   0
    yabai -m config bottom_padding                0
    yabai -m config left_padding                  0
    yabai -m config right_padding                 0
    yabai -m config window_gap                    0


    yabai -m rule --add app="emacs" role="AXTextField" subrole="AXStandardWindow" manage="on"
    # grid="<rows>:<cols>:<start-x>:<start-y>:<width>:<height>"
    yabai -m rule --add app="emacs" role="AXTextField" subrole="AXStandardWindow" title="^${captureTitle}$" manage="off" sticky="on" grid="3:4:2:3:1:1"
    yabai -m rule --add app="Synology Surveillance Station Client" sticky="on" grid="4:4:3:0:1:1"
    yabai -m rule --add app="Dash"                manage="off"
    yabai -m rule --add app="1Password"           manage="off"
    yabai -m rule --add app="System Preferences"  manage="off"
    yabai -m rule --add app="Plexamp"             manage="off"
  '';
  services.skhd.enable = false;
  services.skhd.package = pkgs.skhd;
  services.skhd.skhdConfig =
    let
      modMask = "cmd";
      moveMask = "ctrl + cmd";
      # myCapture = "emacsclient -c -F '((name . \"${captureTitle}\"))' --eval '(peel/org-roam-capture)'";
      myCapture = "nvim";
      myEditor = "nvim";
      myPlayer = "open /Applications/Plexamp.app";
      noop = "/dev/null";
      prefix = "yabai -m";
      fstOrSnd =
        { fst, snd }: domain: "${prefix} ${domain} --focus ${fst} || ${prefix} ${domain} --focus ${snd}";
      nextOrFirst = fstOrSnd {
        fst = "next";
        snd = "first";
      };
      prevOrLast = fstOrSnd {
        fst = "prev";
        snd = "last";
      };
    in
    ''
      # windows ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
      # select
      ${modMask} - j                            : ${prefix} window --focus next || ${prefix} window --focus "$((${prefix} query --spaces --display next || ${prefix} query --spaces --display first) |${pkgs.jq}/bin/jq -re '.[] | select(.visible == 1)."first-window"')" || ${prefix} display --focus next || ${prefix} display --focus first
      ${modMask} - k                            : ${prefix} window --focus prev || ${prefix} window --focus "$((yabai -m query --spaces --display prev || ${prefix} query --spaces --display last) | ${pkgs.jq}/bin/jq -re '.[] | select(.visible == 1)."last-window"')" || ${prefix} display --focus prev || ${prefix} display --focus last

      # close
      ${modMask} - ${keycodes.Delete}           : ${prefix} window --close && yabai -m window --focus prev

      # fullscreen
      ${modMask} - h                            : ${prefix} window --toggle zoom-fullscreen

      # rotate
      ${modMask} - r                            : ${prefix} window --focus smallest && yabai -m window --warp largest && yabai -m window --focus largest

      # increase region
      ${modMask} - ${keycodes.LeftBracket}      : ${prefix} window --resize left:-20:0
      ${modMask} - ${keycodes.RightBracket}     : ${prefix} window --resize right:-20:0

      # spaces ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
      # switch
      ${modMask} + alt - j                      : ${prevOrLast "space"}
      ${modMask} + alt - k                      : ${nextOrFirst "space"}

      # send window
      ${modMask} + ${moveMask} - j              : ${prefix} window --space prev
      ${modMask} + ${moveMask} - k              : ${prefix} window --space next

      # display  ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
      # focus
      ${modMask} - left                         : ${prevOrLast "display"}
      ${modMask} - right                        : ${nextOrFirst "display"}

      # send window
      ${moveMask} - right                       : ${prefix} window --display prev
      ${moveMask} - left                        : ${prefix} window --display next

      # apps  ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
      ${modMask} - return                       : ${myEditor}
      ${modMask} + shift - return               : ${myCapture}
      ${modMask} - p                            : ${myPlayer}


      # reset  ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
      ${modMask} - q                            : pkill yabai; pkill skhd; osascript -e 'display notification "wm restarted"'
    '';
  # fonts.fontDir.enable = true;

  fonts.packages = with pkgs; [
    # delugia-code
    # iosevka
    # intel-one-mono
    (nerdfonts.override {
      fonts = [
        "Monaspace"
        "VictorMono"
        "Hack"
        "JetBrainsMono"
      ];
    })
  ];
  # home.file.".aerospace.toml" = {
  #   source = tomlFormat.generate "aerospace" {
  #     gaps = [
  #       {
  #         inner.horizontal = 0;
  #       }
  #     ];
  #   };
  # };
}
