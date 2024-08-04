local opt = vim.opt -- for conciseness
-- encoding
opt.encoding = "utf-8" -- set encoding to utf-8
opt.fileencoding = "utf-8" -- set file encoding to utf-8

opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- minimum visible text
opt.scrolloff = 5
-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append {"unnamed","unnamedplus"}-- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false



local function copy(lines, _)
  vim.fn.OSCYank(table.concat(lines, "\n"))
end

local function paste()
  return {
    vim.fn.split(vim.fn.getreg(''), '\n'),
    vim.fn.getregtype('')
  }
end

vim.g.clipboard = {
  name = "osc52",
  copy = {
    ["+"] = copy,
    ["*"] = copy
  },
  paste = {
    ["+"] = paste,
    ["*"] = paste
  }
}
