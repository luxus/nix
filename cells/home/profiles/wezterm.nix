{ globals, ... }:
{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.wezterm = {
    enable = true;
    extraConfig =
      # lua
      ''
            -- Add config folder to watchlist for config reloads.
        local wezterm = require("wezterm")
        wezterm.add_to_config_reload_watch_list(wezterm.config_dir)

        -- Reload the configuration every ten minutes
        wezterm.time.call_after(600, function()
        	wezterm.reload_configuration()
        end)
        local font = {
        	family = "MonoLisa",
        	bold = "Medium",
        	weight = "Regular",
        	boldItalic = "Medium Italic",
        	italic = "Regular Italic",
        }
        local function font_with_fallback(name, params)
        	local names = { name, "Apple Color Emoji" }
        	return wezterm.font_with_fallback(names, params)
        end
        -- local function get_theme()
        -- 	local _time = os.date("*t")
        -- 	if _time.hour >= 1 and _time.hour < 9 then
        -- 		return "Rosé Pine (base16)"
        -- 	elseif _time.hour >= 9 and _time.hour < 17 then
        -- 		return "Catppuccin Frappe"
        -- 	elseif _time.hour >= 17 and _time.hour < 21 then
        -- 		return "Catppuccin Mocha"
        -- 	elseif _time.hour >= 21 and _time.hour < 24 or _time.hour >= 0 and _time.hour < 1 then
        -- 		return "kanagawabones"
        -- 	end
        -- end

        -- local process_icons = require("process_icons")
        -- local function conditional_activate_pane(window, pane, pane_direction, vim_direction)
        -- 	if is_vi_process(pane) then
        -- 		window:perform_action(wezterm.action.SendKey({ key = vim_direction, mods = "ALT" }), pane)
        -- 	else
        -- 		window:perform_action(wezterm.action.ActivatePaneDirection(pane_direction), pane)
        -- 	end
        -- end
        --
        -- wezterm.on("ActivatePaneDirection-right", function(window, pane)
        -- 	conditional_activate_pane(window, pane, "Right", "l")
        -- end)
        -- wezterm.on("ActivatePaneDirection-left", function(window, pane)
        -- 	conditional_activate_pane(window, pane, "Left", "h")
        -- end)
        -- wezterm.on("ActivatePaneDirection-up", function(window, pane)
        -- 	conditional_activate_pane(window, pane, "Up", "k")
        -- end)
        -- wezterm.on("ActivatePaneDirection-down", function(window, pane)
        -- 	conditional_activate_pane(window, pane, "Down", "j")
        -- end)
        --
        -- local function get_process(tab)
        -- 	local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")
        --
        -- 	if process_name == "" then
        -- 		process_name = "zsh"
        -- 	end
        --
        -- 	return wezterm.format(process_icons.icons[process_name] or { { Text = string.format("[%s]", process_name) } })
        -- end
        --
        -- local function get_current_working_dir(tab)
        -- 	local current_dir = tab.active_pane.current_working_dir
        -- 	local HOME_DIR = string.format("file://%s", os.getenv("HOME"))
        --
        -- 	return current_dir == HOME_DIR and "~" or string.format("%s", string.gsub(current_dir, "(.*[/\\])(.*)", "%2"))
        -- end
        --
        -- wezterm.on("format-tab-title", function(tab)
        -- 	return wezterm.format({
        -- 		{ Attribute = { Intensity = "Half" } },
        -- 		{ Text = string.format(" %s ", tab.tab_index + 1) },
        -- 		"ResetAttributes",
        -- 		{ Text = get_process(tab) },
        -- 		{ Text = " " },
        -- 		{ Text = get_current_working_dir(tab) },
        -- 		#{ Text = "▕" },
        -- 	})
        -- end)
        --
        -- wezterm.on("update-right-status", function(window)
        -- 	window:set_right_status(wezterm.format({
        -- 		{ Attribute = { Intensity = "Normal" } },
        -- 		{ Text = wezterm.strftime(" %A, %d %B %Y %-H:%M ") },
        -- 	}))
        -- end)
        return {
        	enable_csi_u_key_encoding = true,
        	window_padding = {
        		left = 2,
        		right = 2,
        		top = 2,
        		bottom = 2,
        	},
        	audible_bell = "Disabled",
        	visual_bell = {
        		target = "CursorColor",
        		fade_in_function = "EaseIn",
        		fade_in_duration_ms = 150,
        		fade_out_function = "EaseOut",
        		fade_out_duration_ms = 150,
        	},
        	cursor_thickness = "200%",
        	cursor_blink_ease_in = "Linear",
        	cursor_blink_ease_out = "Linear",
        	default_cursor_style = "BlinkingBlock",
        	cursor_blink_rate = 800,
        	detect_password_input = true,
        	window_decorations = "RESIZE",
        	enable_kitty_keyboard = true,
        	show_new_tab_button_in_tab_bar = false,
        	hide_tab_bar_if_only_one_tab = true,
        	tab_bar_at_bottom = true,
        	font = font_with_fallback({
        		family = font.family,
        		weight = font.weight,
        		harfbuzz_features = { "zero" },
        	}),
        	font_rules = {
        		{
        			intensity = "Bold",
        			font = font_with_fallback({
        				family = font.family,
        				weight = font.bold,
        				harfbuzz_features = { "zero" },
        			}),
        		},
        		{
        			italic = true,
        			intensity = "Bold",
        			font = font_with_fallback({
        				family = font.family,
        				italic = true,
        				weight = font.bold,
        				harfbuzz_features = { "ss02", "zero" },
        			}),
        		},
        		{
        			italic = true,
        			font = font_with_fallback({
        				family = font.family,
        				italic = true,
        				weight = font.weight,
        				harfbuzz_features = { "ss02" },
        			}),
        		},
        	},
        	selection_word_boundary = " \t\n{}[]()\"'`,;:@",
        	term = "wezterm",
        	font_size = 13.0,
        	window_background_opacity = 1,
        	macos_window_background_blur = 20,
        	bold_brightens_ansi_colors = false,
        	color_scheme = 'Catppuccin Mocha'
        }

      '';
  };
  # home.packages = with pkgs; [
  #   bottom
  #   gdu
  #   nodejs_21
  #   lazygit
  #   python3
  #   ripgrep
  #   tree-sitter
  # ];
}
