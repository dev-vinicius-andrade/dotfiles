local adapters_directory = vim.fn.stdpath("config") .. "/lua/plugins/debugging/adapters/"
local function get_adaper_file_relative_path(adapter_file)
	return adapter_file:match("lua/(.+)"):match("(.+).lua"):gsub("/", ".")
end
local function load_adapter(adapter_file)
	-- ex lua/plugins/debugging/adapters/go.lua
	local relative_path = get_adaper_file_relative_path(adapter_file)
	local adapter = require(relative_path)
	return adapter
end
local function get_adapters_files()
	local handle = io.popen('ls "' .. adapters_directory .. '"')
	if handle then
		local adapters = {}
		for filename in handle:lines() do
			if filename:match("%.lua$") then
				local adapter_file = adapters_directory .. filename
				table.insert(adapters, adapter_file)
			end
		end
		handle:close()
		return adapters
	else
		print("Error: Unable to open directory: " .. adapters_directory)
	end
end
local function plugin_builder(adapter_files)
	-- create array of adapters
	local adapters = {}
	for _, adapter_file in ipairs(adapter_files) do
		local adapter = load_adapter(adapter_file)
		table.insert(adapters, adapter)
	end

	local plugin = {
		"mfussenegger/nvim-dap",
		dependencies = { "nvim-neotest/nvim-nio", "rcarriga/nvim-dap-ui" },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()
			for _, adapter in ipairs(adapters) do
				adapter.setup()
			end

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	}
	for _, adapter in ipairs(adapters) do
		if adapter.repository then
			table.insert(plugin.dependencies, adapter.repository)
		end
	end
	return plugin
end

return plugin_builder(get_adapters_files())
