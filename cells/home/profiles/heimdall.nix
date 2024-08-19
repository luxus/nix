{ config
, lib
, pkgs
, ...
}:
let
  tomlFormat = pkgs.formats.toml { };

  # Function to generate key binding configurations
  makeBinding =
    { key
    , modifiers
    , command
    ,
    }:
    {
      key = key;
      modifiers = modifiers;
      command = command;
    };

  # Generate bindings for window and display focus based on direction
  makeFocusBinding =
    direction:
    makeBinding {
      key = lib.strings.substring 0 1 direction;
      modifiers = [ "alt" ];
      command = "yabai -m window --focus ${direction} || yabai -m display --focus ${direction}";
    };

  # Generate bindings for switching to specific spaces
  makeSpaceBinding =
    index:
    makeBinding {
      key = toString index;
      modifiers = [ "alt" ];
      command =
        let
          jqFilter = ".spaces[${toString (index - 1)}]";
        in
        "SPACES=($$(yabai -m query --displays --display | jq '${jqFilter}')) && [[ -n $$SPACES ]] && yabai -m space --focus $$SPACES";
    };

  # List of all focus directions
  directions = [
    "west"
    "south"
    "north"
    "east"
  ];

  # Automatically generate focus bindings
  focusBindings = lib.lists.map makeFocusBinding directions;

  # Automatically generate space bindings for spaces 1 through 4
  spaceBindings = lib.lists.map makeSpaceBinding (lib.lists.generateList lib.id 4);

  # Toggle fullscreen and split bindings
  otherBindings = [
    makeBinding
    {
      key = "f";
      modifiers = [ "alt" ];
      command = "yabai -m window --toggle zoom-fullscreen";
    }
    # makeBinding { key = "f"; modifiers = [ "alt", "shift" ]; command = "yabai -m window --toggle zoom-fullscreen"; }
    # makeBinding { key = "e"; modifiers = [ "alt" ]; command = "yabai -m window --toggle split"; }
  ];

  # Combine all bindings
  allBindings = otherBindings ++ focusBindings ++ spaceBindings;

  configData = {
    bindings = allBindings;
  };
in
{
  home.file = {
    ".config/heimdall/config.toml".source = tomlFormat.generate "heimdall.toml" configData;
  };
  # packages = with pkgs; [ jankyborders ];
}
