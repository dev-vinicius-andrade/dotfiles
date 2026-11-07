local function set_keymaps_on_lsp_attach(ev)
	local keymap = vim.keymap
	local opts = {
		buffer = ev.buf,
		silent = true,
	}

	local mappings = {
		{ "gR", "<cmd>Telescope lsp_references<CR>", "Show LSP references" },
		{ "gD", vim.lsp.buf.declaration, "Go to declaration" },
		{ "gd", "<cmd>Telescope lsp_definitions<CR>", "Show LSP definitions" },
		{ "gi", "<cmd>Telescope lsp_implementations<CR>", "Show LSP implementations" },
		{ "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Show LSP type definitions" },
		{ "<leader>ca", vim.lsp.buf.code_action, "See available code actions" },
		{ "<leader>rn", vim.lsp.buf.rename, "Smart rename" },
		{ "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Show buffer diagnostics" },
		{ "K", vim.lsp.buf.hover, "Show documentation for what is under cursor" },
		{ "<leader>rs", ":LspRestart<CR>", "Restart LSP" },
	}

	for _, mapping in ipairs(mappings) do
		opts.desc = mapping[3]
		keymap.set("n", mapping[1], mapping[2], opts)
	end
end

-- Every file in lua/plugins/lsp/servers/<name>.lua returns a vim.lsp.config table for <name>.
local function load_lsp_servers()
	local servers = {}
	local dir = vim.fn.stdpath("config") .. "/lua/plugins/lsp/servers"
	for name, kind in vim.fs.dir(dir) do
		if kind == "file" and name:match("%.lua$") then
			local server_name = name:gsub("%.lua$", "")
			servers[server_name] = require("plugins.lsp.servers." .. server_name)
		end
	end
	return servers
end

-- Neovim >= 0.11 native LSP config. Enabling (vim.lsp.enable) is done by
-- mason-lspconfig in mason.lua; this only registers the settings, which apply
-- to every client started afterwards.
local function configure_lsp_servers(capabilities)
	vim.lsp.config("*", { capabilities = capabilities })
	for server_name, server in pairs(load_lsp_servers()) do
		vim.lsp.config(server_name, server)
	end
end

return {
	"neovim/nvim-lspconfig", -- still provides the default server configs (cmd, filetypes, root markers)
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{
			"antosha417/nvim-lsp-file-operations",
			config = true,
		},
		{
			"folke/lazydev.nvim", -- replaces the archived neodev.nvim
			ft = "lua",
			opts = {
				library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
			},
		},
	},
	config = function()
		local capabilities = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			require("cmp_nvim_lsp").default_capabilities()
		)
		configure_lsp_servers(capabilities)
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = set_keymaps_on_lsp_attach,
		})
	end,
}
