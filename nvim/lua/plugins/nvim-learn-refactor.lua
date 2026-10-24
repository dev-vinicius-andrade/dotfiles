return {
  "dev-vinicius-andrade/nvim-learn-refactor",
  cmd = { "Refactor", "RefactorLibrary", "RefactorStats", "RefactorConfigTips" },
  keys = { 
    { "<leader>Rr", "<cmd>Refactor<cr>", desc = "Refactor: start challenge" },
    { "<leader>Rm", "<cmd>RefactorMenu<cr>", desc = "Refactor: menu" }
  },
  opts = { 
    keymaps = false,
    data_dir = vim.fn.stdpath("data") .. "/learn-refactor",
    provider = "openai",
    languages = {
      typescript = { ext = "ts" },
      go         = { ext = "go" },
      csharp     = { ext = "cs" },
    },
    ollama = {
      model = "qwen2.5-coder:14b",
      auto_start = true,   -- starts the container on demand
    },
    routes = {
      easy = { provider = "openai" },
      medium = { provider = "openai" },
      hard = { provider = "anthropic" },
      expert = { provider = "anthropic" }
    } 
  }
}
