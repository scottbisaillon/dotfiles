local wezterm = require('wezterm')
local config = {}

config.default_prog = { 'pwsh.exe', '-NoLogo' }

config.enable_tab_bar = false
config.font = wezterm.font('JetBrainsMono Nerd Font')
config.font_size = 14.0
config.color_scheme = 'GruvboxDark'

return config
