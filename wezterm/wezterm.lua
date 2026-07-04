local wezterm = require('wezterm')
local config = {}

config.default_prog = { 'pwsh.exe', '-NoLogo' }

config.enable_tab_bar = false

-- Honor the Kitty Keyboard Protocol so apps can disambiguate keychords like
-- <C-Space>, <C-i>/<Tab>, <C-/> etc. Off by default in WezTerm; without it
-- Ctrl+Space is sent as a NUL byte and never reaches Neovim as <C-Space>.
config.enable_kitty_keyboard = true
config.font = wezterm.font('JetBrainsMono Nerd Font')
config.font_size = 14.0
config.color_scheme = 'GruvboxDark'

return config
