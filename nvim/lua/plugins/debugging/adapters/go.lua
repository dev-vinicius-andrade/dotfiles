return {
	repository = "leoluz/nvim-dap-go",
	setup = function()
		local adapter = require("dap-go")
		adapter.setup({
			dap_configurations = {
				{
					type = "go",
					name = "Attach remote",
					mode = "remote",
					request = "attach",
				},
			},
		})
	end,
}
