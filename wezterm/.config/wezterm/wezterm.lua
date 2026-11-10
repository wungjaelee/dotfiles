local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "rose-pine-moon"
config.max_fps = 120
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 15.0
config.macos_window_background_blur = 50
config.enable_tab_bar = true

local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
bar.apply_to_config(config)

config.window_decorations = "RESIZE"
config.inactive_pane_hsb = {
  saturation = 0.0,
  brightness = 0.5,
}

return config
