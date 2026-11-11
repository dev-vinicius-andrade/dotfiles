return {
  {
    "andradev-io/nvim-skill-arcade",
    url = "https://github.com/andradev-io/nvim-skill-arcade.git",
    cmd = {
      "Arcade", "ArcadeMenu", "ArcadeRun", "ArcadeDaily", "ArcadePractice", "ArcadeToggle", "ArcadePause",
      "ArcadePlay", "ArcadeSkip", "ArcadeHint", "ArcadeNext", "ArcadeQuit", "ArcadeStats", "ArcadeSetup",
      "ArcadeGenerate",
    },
    keys = {
      { "<leader>Gm", "<cmd>ArcadeMenu<cr>", desc = "Arcade: menu" },
      { "<leader>Gg", "<cmd>ArcadeRun<cr>", desc = "Arcade: start a run" },
      { "<leader>Gd", "<cmd>ArcadeDaily<cr>", desc = "Arcade: daily challenge" },
      { "<leader>Gr", "<cmd>ArcadePractice<cr>", desc = "Arcade: practice an area" },
      { "<leader>Gp", "<cmd>ArcadeToggle<cr>", desc = "Arcade: pause / resume" },
      { "<leader>Gs", "<cmd>ArcadeSkip<cr>", desc = "Arcade: skip" },
      { "<leader>Gh", "<cmd>ArcadeHint<cr>", desc = "Arcade: hint" },
      { "<leader>Gn", "<cmd>ArcadeNext<cr>", desc = "Arcade: next challenge" },
      { "<leader>Gq", "<cmd>ArcadeQuit<cr>", desc = "Arcade: quit run" },
      { "<leader>Gt", "<cmd>ArcadeStats<cr>", desc = "Arcade: stats" },
      { "<leader>Ge", "<cmd>ArcadeSetup<cr>", desc = "Arcade: what the game found in my setup" },
    },
    opts = {
      keymaps = false, -- `keys` above owns the mappings
    },
  },
  { "folke/which-key.nvim", optional = true, opts = { spec = { { "<leader>G", group = "skill arcade" } } } },
}
