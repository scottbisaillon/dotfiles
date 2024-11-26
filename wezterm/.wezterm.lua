local wezterm = require("wezterm")
local act = wezterm.action

-- local function isViProcess(pane)
-- 	return pane:get_foreground_process_name():find("n?vim") ~= nil or pane:get_title():find("n?vim") ~= nil
-- end
--
-- local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
-- 	if isViProcess(pane) then
-- 		window:perform_action(act.SendKey({ key = vim_direction, mods = "CTRL" }), pane)
-- 	else
-- 		window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
-- 	end
-- end
--
-- wezterm.on("ActivatePaneDirection-right", function(window, pane)
-- 	conditionalActivatePane(window, pane, "Right", "l")
-- end)
-- wezterm.on("ActivatePaneDirection-left", function(window, pane)
-- 	conditionalActivatePane(window, pane, "Left", "h")
-- end)
-- wezterm.on("ActivatePaneDirection-up", function(window, pane)
-- 	conditionalActivatePane(window, pane, "Up", "k")
-- end)
-- wezterm.on("ActivatePaneDirection-down", function(window, pane)
-- 	conditionalActivatePane(window, pane, "Down", "j")
-- end)

local config = wezterm.config_builder()

config.color_scheme = "catppuccin-mocha"
config.enable_tab_bar = false
config.font = wezterm.font("JetBrains Mono")

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- config.disable_default_key_bindings = true

config.keys = {
	-- 	{ key = "h", mods = "CTRL", action = act.EmitEvent("ActivatePaneDirection-left") },
	-- 	{ key = "j", mods = "CTRL", action = act.EmitEvent("ActivatePaneDirection-down") },
	-- 	{ key = "k", mods = "CTRL", action = act.EmitEvent("ActivatePaneDirection-up") },
	-- 	{ key = "l", mods = "CTRL", action = act.EmitEvent("ActivatePaneDirection-right") },
}

return config
