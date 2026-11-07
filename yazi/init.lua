-- Plugin setup. Each is wrapped in pcall so a machine that hasn't run
-- `ya pkg install` yet still starts yazi cleanly.
local function setup(name, opts)
	local ok, plugin = pcall(require, name)
	if ok then
		plugin:setup(opts)
	end
end

setup("full-border", { set = "rounded" })
setup("git", { order = 1500 })

-- show the user/group in the status bar (handy with chmod)
Status:children_add(function()
	local h = cx.active.current.hovered
	if not h or ya.target_family() ~= "unix" then
		return ""
	end
	return ui.Line({
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		":",
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		" ",
	})
end, 500, Status.RIGHT)
