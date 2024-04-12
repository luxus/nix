{ globals, ... }:
{
  config,
  lib,
  pkgs,
  ...
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
in
with builtins // lib;
{
  services.sketchybar = {
    enable = true;
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
  fonts.fontDir.enable = true;

  fonts.fonts = with pkgs; [
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
