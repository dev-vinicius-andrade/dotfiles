return {
  'aimdevlee/herdr-nvim-nav',
  dependencies = { 'christoomey/vim-tmux-navigator' }, -- omit if with_tmux = false
  config = function()
    require('herdr-nvim-nav').setup()
  end,
}
