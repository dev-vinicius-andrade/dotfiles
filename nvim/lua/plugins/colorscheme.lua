function set_debbuging_colors()
	local colors = {
		DapBreakpoint = "#993939",
		DapLogPoint = "#61afef",
		DapStopped = "#98c379",
	}
	vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = colors.DapBreakpoint })
	vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = colors.DapLogPoint })
	vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = colors.DapStopped })
	vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
	vim.fn.sign_define("DapBreakpointCondition", { text = " ﳁ", texthl = "DapBreakpoint", fg = colors.DapBreakpoint })
	vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DapBreakpoint", fg = colors.DapBreakpoint })
	vim.fn.sign_define("DapLogPoint", { text = " ", texthl = "DapLogPoint", fg = colors.DapLogPoint })
	vim.fn.sign_define("DapStopped", { text = " ", texthl = "DapStopped", fg = colors.DapStopped })
end
return {
	{
		"folke/tokyonight.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			local bg = "#1c1c1c"
			local bg_dark = "#1f1f1f"
			local bg_highlight = "#143652"
			local bg_search = "#0A64AC"
			local bg_visual = "#275378"
			local fg = "#CBE0F0"
			local fg_dark = "#B4D0E9"
			local fg_gutter = "#627E97"
			local border = "#547998"

			require("tokyonight").setup({
				style = "night",
				on_colors = function(colors)
					colors.bg = bg
					colors.bg_dark = bg_dark
					colors.bg_float = bg_dark
					colors.bg_highlight = bg_highlight
					colors.bg_popup = bg_dark
					colors.bg_search = bg_search
					colors.bg_sidebar = bg_dark
					colors.bg_statusline = bg_dark
					colors.bg_visual = bg_visual
					colors.border = border
					colors.fg = fg
					colors.fg_dark = fg_dark
					colors.fg_float = fg
					colors.fg_gutter = fg_gutter
					colors.fg_sidebar = fg_dark
				end,
			})
			-- load the colorscheme here
			vim.cmd([[colorscheme tokyonight]])
			set_debbuging_colors()
		end,
	},
}
