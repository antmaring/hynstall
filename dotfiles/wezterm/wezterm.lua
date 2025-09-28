local wezterm = require 'wezterm'

return {
  enable_wayland = false,
  window_background_opacity = 0.8, -- valor entre 0.0 y 1.0 para transparencia
  text_background_opacity = 1.0, -- opacidad del fondo de texto, opcional
  font = wezterm.font("Fira Code"),
  font_size = 18,
  enable_tab_bar = false,
  color_scheme = "Catppuccin Mocha",
  scrollback_lines = 10000,
  --default_prog = { "/usr/bin/fish" },
}
