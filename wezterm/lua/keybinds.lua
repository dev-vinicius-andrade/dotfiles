local wezterm = require 'wezterm'
local module = {}

function module.apply_config(config)
    config.keys = {{
        key = ' ',
        mods = 'CTRL',
        action = wezterm.action.ShowLauncher
    }}

end
return module
