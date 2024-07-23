local mandatory_languages = {
    bash = "bashls",
    json = {"jsonls", "biome"},
    javascript = {"quick_lint_js", "vtsls", "tsserver"},
    lua = "lua_ls",
    powershell = "powershell_es",
    sql = {"sqlls", "sqls"}
}
local function read_json_file(file_path)
    local file = io.open(file_path, "r")
    if not file then
        return nil
    end
    local content = file:read("*a")
    file:close()
    return vim.fn.json_decode(content)
end
local languages_to_install_path = vim.fn.stdpath("config") .. "/nvim-mson-languages-to-install.json"
local optional_languages = read_json_file(languages_to_install_path) or {}
local function merge_tables(t1, t2)
    for k, v in pairs(t2) do
        if t1[k] then
            if type(t1[k]) == "table" and type(v) == "table" then
                for _, val in ipairs(v) do
                    table.insert(t1[k], val)
                end
            elseif type(t1[k]) == "table" then
                table.insert(t1[k], v)
            else
                t1[k] = {t1[k], v}
            end
        else
            t1[k] = v
        end
    end
end
local languages_to_install = vim.deepcopy(mandatory_languages)
merge_tables(languages_to_install, optional_languages)
return {
    "williamboman/mason.nvim",
    dependencies = {"williamboman/mason-lspconfig.nvim", "WhoIsSethDaniel/mason-tool-installer.nvim"},
    config = function()
        -- import mason
        local mason = require("mason")

        -- import mason-lspconfig
        local mason_lspconfig = require("mason-lspconfig")
        local mason_tool_installer = require("mason-tool-installer")
        -- enable mason and configure icons
        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        })

        mason_lspconfig.setup({
            -- list of servers for mason to install
            ensure_installed = languages_to_install
        })
        mason_tool_installer.setup({
            ensure_installed = {
                -- "prettier", -- prettier formatter
                -- "stylua", -- lua formatter
                -- "isort", -- python formatter
                -- "black", -- python formatter
                -- "pylint", -- python linter
                -- "eslint_d" -- js linter
            }
        })
    end
}
-- local languages_to_install = {
--     bash = "bashls",
--     csharp = {"csharp_ls", "omnisharp_mono", "omnisharp"},
--     c = "cmake",
--     html = "html",
--     json = {"jsonls", "biome"},
--     css = {"somesass_ls", "cssls", "cssmodules_ls", "tailwindcss"},
--     javascript = {"quick_lint_js", "vtsls", "tsserver"},
--     docker = {"dockerls", "docker_compose_language_service"},
--     go = {"golangci_lint_ls", "gopls"},
--     angular = "angularls",
--     vue = {"vuels", "volar"},
--     lua = "lua_ls",
--     graphql = "graphql",
--     python = {"pyright", "basedpyright", "jedi_language_server", "pyre", "sourcery", "pylsp", "ruff_lsp"},
--     powershell = "powershell_es",
--     sql = {"sqlls", "sqls"}
-- }
-- return {
--     "williamboman/mason.nvim",
--     dependencies = {"williamboman/mason-lspconfig.nvim", "WhoIsSethDaniel/mason-tool-installer.nvim"},
--     config = function()
--         -- import mason
--         local mason = require("mason")

--         -- import mason-lspconfig
--         local mason_lspconfig = require("mason-lspconfig")
--         local mason_tool_installer = require("mason-tool-installer")
--         -- enable mason and configure icons
--         mason.setup({
--             ui = {
--                 icons = {
--                     package_installed = "✓",
--                     package_pending = "➜",
--                     package_uninstalled = "✗"
--                 }
--             }
--         })

--         mason_lspconfig.setup({
--             -- list of servers for mason to install
--             ensure_installed = languages_to_install
--         })
--         mason_tool_installer.setup({
--             ensure_installed = {"prettier", -- prettier formatter
--             "stylua", -- lua formatter
--             "isort", -- python formatter
--             "black", -- python formatter
--             "pylint", -- python linter
--             "eslint_d" -- js linter
--             }
--         })
--     end
-- }
