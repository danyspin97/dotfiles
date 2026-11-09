-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Monokai Soda (Gogh)"

-- config.font = wezterm.font("Lilex Nerd Font")
-- config.font = wezterm.font("Maple Mono")
config.font = wezterm.font("Victor Mono")
-- config.font = wezterm.font("Iosevka SS01")

config.hide_tab_bar_if_only_one_tab = true

config.font_size = 11

config.enable_kitty_graphics = true

config.window_decorations = "NONE"

-- and finally, return the configuration to wezterm
return config
