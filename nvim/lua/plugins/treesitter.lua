-- nvim-treesitter `main` branch: setup() only takes `install_dir`. It only
-- installs parsers and queries; highlighting, indent and selection are
-- enabled here (highlighting and selection are built into Neovim >= 0.12).
-- Building parsers needs the `tree-sitter` CLI (>= 0.26) on PATH.
local parsers = {
  "angular", "go", "gomod", "gosum", "gotmpl", "gowork", "c_sharp", "json", "json5",
  "javascript", "typescript", "tsx", "yaml", "html", "css", "markdown", "markdown_inline",
  "graphql", "bash", "lua", "luadoc", "vim", "vue", "ssh_config", "dockerfile",
  "gitignore", "query", "vimdoc", "scss", "kdl",
}

-- Start highlighting and indent for any buffer whose language has a parser.
local function attach(ev)
  local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
  if not lang or not vim.treesitter.language.add(lang) then
    return
  end
  if not pcall(vim.treesitter.start, ev.buf, lang) then
    return
  end
  if #vim.api.nvim_get_runtime_file("queries/" .. lang .. "/indents.scm", false) > 0 then
    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

-- Incremental selection on top of Neovim's built-in `an` / `in` node selection.
local function set_selection_keymaps()
  vim.keymap.set("n", "<C-space>", "van", { remap = true, desc = "Start treesitter selection" })
  vim.keymap.set("x", "<C-space>", "an", { remap = true, desc = "Grow treesitter selection" })
  vim.keymap.set("x", "<bs>", "in", { remap = true, desc = "Shrink treesitter selection" })
end

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
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
    require("nvim-treesitter").install(parsers) -- async; no-op for parsers already installed

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
      callback = attach,
    })
    set_selection_keymaps()
  end,
}
