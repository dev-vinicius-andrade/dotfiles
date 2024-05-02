require("core")
require("core.lazy")

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_augroup("alpha_on_empty", { clear = true })
vim.api.nvim_create_autocmd("User", {
	pattern = "BDeletePre *",
	group = "alpha_on_empty",
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		local name = vim.api.nvim_buf_get_name(bufnr)

		if name == "" then
			vim.cmd([[:Alpha | bd#]])
		end
	end,
})

vim.api.nvim_create_autocmd({ "UIEnter" }, {
	pattern = "*",
	callback = function(data)
		local path = data.file
		local is_nvim_tree = string.find(path, "/NvimTree_")
		if is_nvim_tree then
			vim.cmd([[:NvimTreeToggle]])
			vim.cmd([[:Alpha]])
		end
	end,
})
