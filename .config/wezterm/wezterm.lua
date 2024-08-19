local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.enable_tab_bar = false
config.font = wezterm.font 'SF Mono'
config.font_size = 14
config.color_scheme = 'Catppuccin Mocha'
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

return config
