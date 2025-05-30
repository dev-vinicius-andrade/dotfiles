return {
  "nvim-pack/nvim-spectre",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = "Spectre",
  keys = {
    {
      "<leader>fra",
      function()
        require("spectre").toggle()
      end,
      desc = "Search and Replace (Spectre)",
    },
    {
      "C-S-f",
      function()
        require("spectre").toggle()
      end,
      desc = "Search and Replace (Spectre)",
    },

  },
  config = function()
    -- optional: customize Spectre here
    require("spectre").setup()
  end,
}

