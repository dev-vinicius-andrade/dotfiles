return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false, -- Treesitter should not be lazy-loaded to prevent Telescope/LSP race conditions
  build = ":TSUpdate",
  dependencies = {
    {
      "windwp/nvim-ts-autotag",
      opts = {}, -- modern nvim-ts-autotag sets up via its own opts
    },
    "nvim-treesitter/nvim-treesitter-context",
  },
  config = function()
    -- CHANGED: Updated from "nvim-treesitter.configs" to match the new API
    local treesitter = require("nvim-treesitter")

    treesitter.setup({
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
      ensure_installed = {
        "angular", "go", "gomod", "gosum", "gotmpl", "gowork", "c_sharp", "json", "json5",
        "javascript", "typescript", "tsx", "yaml", "html", "css", "markdown", "markdown_inline",
        "graphql", "bash", "lua", "luadoc", "vim", "vue", "ssh_config", "dockerfile",
        "gitignore", "query", "vimdoc", "scss", "kdl",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
