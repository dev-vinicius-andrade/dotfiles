local keymap = vim.keymap

local function number_increment_decrement_keymaps()
    keymap.set("n", "<leader>+", "<C-a>", {
        desc = "Increment number"
    })
    keymap.set("n", "<leader>-", "<C-x>", {
        desc = "Decrement number"
    })
end
local function split_windows_keymaps()
    keymap.set("n", "<leader>sv", "<C-w>v", {
        desc = "Split window vertically"
    })
    keymap.set("n", "<leader>sh", "<C-w>s", {
        desc = "Split window horizontally"
    })
    keymap.set("n", "<leader>se", "<C-w>=", {
        desc = "Make splits equal size"
    })
    keymap.set("n", "<leader>sx", "<cmd>close<CR>", {
        desc = "Close current split"
    })
end
local function tabs_keymaps()
    keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", {
        desc = "Open new tab"
    }) -- open new tab
    keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", {
        desc = "Close current tab"
    }) -- close current tab
    keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", {
        desc = "Go to next tab"
    }) --  go to next tab
    keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", {
        desc = "Go to previous tab"
    }) --  go to previous tab
    keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", {
        desc = "Open current buffer in new tab"
    })
    keymap.set("n", "<C-<Tab>>", "<cmd>tabnext<CR>", {
        desc = "Go to next tab"
    })
    keymap.set("n", "<C-<S-Tab>>", "<cmd>tabprevious<CR>", {
        desc = "Go to previous tab"
    })
    keymap.set("i", "<C-<Tab>>", "<cmd>tabnext<CR>", {
        desc = "Go to next tab"
    })
    keymap.set("i", "<C-<S-Tab>>", "<cmd>tabprevious<CR>", {
        desc = "Go to previous tab"
    })
    keymap.set("n", "<TAB>", ":bn<CR>")
    keymap.set("n", "<S-TAB>", ":bp<CR>")
    keymap.set("n", "<leader>bd", ":bd<CR>") -- from Doom Emacs
end
local function disable_arrow_key_movement()
    keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
    keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
    keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
    keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>') --  move current buffer to new tab
end
local function file_explorer_keymaps()
    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", {
        desc = "Toggle file explorer"
    }) -- toggle file explorer
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", {
        desc = "Toggle file explorer on current file"
    }) -- toggle file explorer on current file
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", {
        desc = "Collapse file explorer"
    }) -- collapse file explorer
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", {
        desc = "Refresh file explorer"
    }) -- refresh file explorer
end
local function move_content_up_and_down_keymaps()
    keymap.set("v", "J", ":m '>+1<CR>gv=gv")
    keymap.set("v", "K", ":m '<-2<CR>gv=gv")
end
local function diagnostics_keymaps()
    keymap.set("n", "[d", vim.diagnostic.goto_prev, {
        desc = "Go to previous [D]iagnostic message"
    })
    keymap.set("n", "]d", vim.diagnostic.goto_next, {
        desc = "Go to next [D]iagnostic message"
    })
    keymap.set("n", "<leader>e", vim.diagnostic.open_float, {
        desc = "Show diagnostic [E]rror messages"
    })
    keymap.set("n", "<leader>q", vim.diagnostic.setloclist, {
        desc = "Open diagnostic [Q]uickfix list"
    })
end
local function noice_keymaps()
    keymap.set("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", {
        desc = "Dismiss noice"
    })
end
local function identention_keymaps()
    keymap.set("v", "<", "<gv")
    keymap.set("v", ">", ">gv")
end
local function telescope_keymaps()
    local builtin = require("telescope.builtin") -- for conciseness

    keymap.set("n", "<leader>fg", builtin.git_files, {
        desc = "Fuzzy find git files in cwd"
    })
    keymap.set("n", "<leader>ff", builtin.find_files, {
        desc = "Fuzzy find files in cwd"
    })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", {
        desc = "Fuzzy find recent files"
    })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", {
        desc = "Find string under cursor in cwd"
    })
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", {
        desc = "Find todos"
    })
    keymap.set("n", "<leader>fb", builtin.buffers, {
        desc = "Find Buffers"
    })
    keymap.set("n", "<leader>fh", builtin.help_tags, {
        desc = "Find Help Tags"
    })
    keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, {
        desc = "Find Symbols"
    })
    keymap.set("n", "<leader>fi", "<cmd>AdvancedGitSearch<CR>", {
        desc = "AdvancedGitSearch"
    })
    keymap.set("n", "<leader>fo", builtin.oldfiles, {
        desc = "Find Old Files"
    })
    keymap.set("n", "<leader>fw", builtin.grep_string, {
        desc = "Find Word under Cursor"
    })
    keymap.set("n", "<leader>fgc", builtin.git_commits, {
        desc = "Search Git Commits"
    })
    keymap.set("n", "<leader>fgb", builtin.git_bcommits, {
        desc = "Search Git Commits for Buffer"
    })
    keymap.set("n", "<leader>ps", function()
        print(vim.fn.getcwd())
        local git_directory = vim.fn.getcwd() .. "/.git"
        local glob_ignore_git_directory = "--glob='!" .. git_directory .. "'"

        builtin.grep_string({
            search = vim.fn.input("Grep > "),
            search_dirs = {vim.fn.getcwd()},
            additional_args = {"--follow", "--hidden", "--ignore-file", ".gitignore"}
        })
    end, {
        desc = "Find string in project"
    })
end
local function jump_to_end_of_word_keymaps()
    keymap.set({"i"}, "<A-Right>", "<C-o>w", {
        noremap = true,
        silent = true,
        desc = "Jump to end of word"
    })
    keymap.set({"i"}, "<A-Left>", "<C-o>b", {
        noremap = true,
        silent = true,
        desc = "Jump to begining of word"
    })
end
local function debugging_keymaps()
    local dap = require("dap")
    keymap.set("n", "<F5>", function()
        dap.continue()
    end)
    keymap.set("n", "<F10>", function()
        dap.step_over()
    end)
    keymap.set("n", "<F11>", function()
        dap.step_into()
    end)
    keymap.set("n", "<F12>", function()
        dap.step_out()
    end)
    keymap.set("n", "<Leader>b", function()
        dap.toggle_breakpoint()
    end)
    keymap.set("n", "<Leader>B", function()
        dap.set_breakpoint()
    end)
    keymap.set("n", "<Leader>lp", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end)
    keymap.set("n", "<Leader>dr", function()
        dap.repl.open()
    end)
    keymap.set("n", "<Leader>dl", function()
        dap.run_last()
    end)
    keymap.set({"n", "v"}, "<Leader>dh", function()
        require("dap.ui.widgets").hover()
    end)
    keymap.set({"n", "v"}, "<Leader>dp", function()
        require("dap.ui.widgets").preview()
    end)
    keymap.set("n", "<Leader>df", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.frames)
    end)
    keymap.set("n", "<Leader>ds", function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.scopes)
    end)
end
local function auto_session_keymaps()
    keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", {
        desc = "Restore session for cwd"
    }) -- restore last workspace session for current directory
    keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", {
        desc = "Save session for auto session root dir"
    }) -- save workspace session for current working directory
end
local function substitute_keymaps()
    local substitute = require("substitute")
    keymap.set("n", "s", substitute.operator, {
        desc = "Substitute with motion"
    })
    keymap.set("n", "ss", substitute.line, {
        desc = "Substitute line"
    })
    keymap.set("n", "S", substitute.eol, {
        desc = "Substitute to end of line"
    })
    keymap.set("x", "s", substitute.visual, {
        desc = "Substitute in visual mode"
    })
end
local function todo_comments_keymaps()
    local todo_comments = require("todo-comments")

    keymap.set("n", "]t", function()
        todo_comments.jump_next()
    end, {
        desc = "Next todo comment"
    })

    keymap.set("n", "[t", function()
        todo_comments.jump_prev()
    end, {
        desc = "Previous todo comment"
    })
end
local function window_size_keymaps()
    keymap.set("n", "<C-Up>", ":resize -2<CR>")
    keymap.set("n", "<C-Down>", ":resize +2<CR>")
    keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
    keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")
end
local function return_to_normal_mode()
    keymap.set("i", "jj", "<ESC>", {
        noremap = true,
        silent = true,
        desc = "Return to normal mode"
    })
end
local function deselect_visual_mode()
    keymap.set("n", "<ESC>", "<cmd>nohlsearch<cr>", {
        noremap = true,
        silent = true,
        desc = "Deselect visual mode"
    })
end

local function navigator()

    keymap.set("n", "<C-h>", "<CMD>NavigatorLeft<CR>")
    keymap.set("n", "<C-j>", "<CMD>NavigatorDown<CR>")
    keymap.set("n", "<C-k>", "<CMD>NavigatorUp<CR>")
    keymap.set("n", "<C-l>", "<CMD>NavigatorRight<CR>")
end
local function lazy_git()
    keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>", {
        desc = "Open lazy git"
    })
end
local function copy_to_clipboard()

    keymap.set({"n","v"}, "<leader>y", [["+y]], {
        noremap = true,
        silent = true
    })
    -- keymap.set("v", "<leader>ctc", '"+y', {
    --     noremap = true,
    --     silent = true
    -- })
    --     keymap.set("v", "<leader>ctcm", function()
    --         vim.cmd("normal! " .. vim.fn.visualMode() .. 'y"')
    --     end, {
    --         noremap = true,
    --         silent = true
    --     })
end
return {
    "codescovery/lazy-remap.nvim",
    event = "VeryLazy",

    config = function()
        copy_to_clipboard()
        number_increment_decrement_keymaps()
        split_windows_keymaps()
        tabs_keymaps()
        disable_arrow_key_movement()
        file_explorer_keymaps()
        move_content_up_and_down_keymaps()
        diagnostics_keymaps()
        noice_keymaps()
        debugging_keymaps()
        identention_keymaps()
        telescope_keymaps()
        auto_session_keymaps()
        substitute_keymaps()
        todo_comments_keymaps()
        window_size_keymaps()
        jump_to_end_of_word_keymaps()
        return_to_normal_mode()
        deselect_visual_mode()
        navigator()
        lazy_git()
    end
}

