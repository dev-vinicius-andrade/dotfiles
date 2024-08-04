return {
  "ojroques/vim-oscyank",
config = function()
            -- Ensure OSCYankString is available
            vim.cmd([[runtime! plugin/oscyank.vim]])
        end,
}
