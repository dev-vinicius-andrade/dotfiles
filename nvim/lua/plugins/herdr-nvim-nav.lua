-- Ctrl+h/j/k/l across Neovim splits and herdr panes.
-- Needs the herdr side too: `herdr plugin install aimdevlee/herdr-nvim-nav`
-- (bound in herdr/config.toml). No tmux, so vim-tmux-navigator isn't needed.
return {
  "aimdevlee/herdr-nvim-nav",
  config = function()
    require("herdr-nvim-nav").setup({ with_tmux = false })
  end,
}
