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
		{ "<leader>d", vim.diagnostic.open_float, "Show line diagnostics" },
		{ "[d", vim.diagnostic.goto_prev, "Go to previous diagnostic" },
		{ "]d", vim.diagnostic.goto_next, "Go to next diagnostic" },
		{ "K", vim.lsp.buf.hover, "Show documentation for what is under cursor" },
		{ "<leader>rs", ":LspRestart<CR>", "Restart LSP" },
	}

	for _, mapping in ipairs(mappings) do
		opts.desc = mapping[3]
		keymap.set("n", mapping[1], mapping[2], opts)
	end
end

local function configure_lsp_servers(capabilities, lspconfig)
	local servers = {
		emmet_ls = require("plugins.lsp.servers.emmet_ls"),
		graphql = require("plugins.lsp.servers.graphql"),
		lua_ls = require("plugins.lsp.servers.lua_ls"),
		omnisharp = require("plugins.lsp.servers.omnisharp"),
		omnisharp_mono = require("plugins.lsp.servers.omnisharp_mono"),
		svelte = require("plugins.lsp.servers.svelte"),
	}
	local mason_lspconfig = require("mason-lspconfig")
	mason_lspconfig.setup({
		handlers = {
			function(server_name)
				local server = servers[server_name] or {}
				server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
				if server_name == "omnisharp_mono" then
					return
				end

				lspconfig[server_name].setup(server)
			end,
		},
	})
end

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{
			"antosha417/nvim-lsp-file-operations",
			config = true,
		},
		{
			"folke/neodev.nvim",
			opts = {},
		},
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason = require("mason")
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
		mason.setup()
		configure_lsp_servers(capabilities, lspconfig)
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = set_keymaps_on_lsp_attach,
		})
	end,
}
