local languages_to_install = {
    bash = "bashls",
    csharp = {"csharp_ls", "omnisharp_mono", "omnisharp"},
    c = "cmake",
    html = "html",
    json = {"jsonls", "biome"},
    css = {"somesass_ls", "cssls", "cssmodules_ls", "tailwindcss"},
    javascript = {"quick_lint_js", "vtsls", "tsserver"},
    docker = {"dockerls", "docker_compose_language_service"},
    go = {"golangci_lint_ls", "gopls"},
    angular = "angularls",
    vue = {"vuels", "volar"},
    lua = "lua_ls",
    graphql = "graphql",
    python = {"pyright", "basedpyright", "jedi_language_server", "pyre", "sourcery", "pylsp", "ruff_lsp"},
    powershell = "powershell_es",
    sql = {"sqlls", "sqls"}
}
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
            ensure_installed = {"prettier", -- prettier formatter
            "stylua", -- lua formatter
            "isort", -- python formatter
            "black", -- python formatter
            "pylint", -- python linter
            "eslint_d" -- js linter
            }
        })
    end
}
