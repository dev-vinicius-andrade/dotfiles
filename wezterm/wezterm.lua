-- Pull in the wezterm API
local wezterm = require 'wezterm'
local keybinds = require "lua.keybinds"
local keytables = require "lua.keytables"
local events_handlers = require "lua.events_handlers"
local launch_menu = require "lua.launch_menu"
local config = wezterm.config_builder()
config.color_scheme = 'Vs Code Dark+ (Gogh)'
config.font = wezterm.font('JetBrains Mono')
config.default_prog = {'powershell.exe'}
-- events_handlers.setup()
keybinds.apply_config(config)
-- keytables.apply_config(config)
launch_menu.apply_config(config)

return config
