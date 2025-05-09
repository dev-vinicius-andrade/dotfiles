local wezterm = require 'wezterm'
local module = {}
function on_set_tab_title()
    wezterm.on("set-tab-title", function(window, pane, title)
        window:set_title(title)
    end)
end
function module.setup()
    on_set_tab_title()
end

return module
