local mandatory_languages = {
    lua = "lua_ls"
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
local install_config_path = vim.fn.stdpath("config") .. "/nvim-mason-install-configuration.json"
local install_config = read_json_file(install_config_path) or {}
local optional_languages = install_config.languages or {}
local tools_to_install = install_config.tools or {}
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

local function flatten_languages(languages)
    local result = {}
    for _, servers in pairs(languages) do
        if type(servers) == "table" then
            for _, server in ipairs(servers) do
                table.insert(result, server)
            end
        else
            table.insert(result, servers)
        end
    end
    return result
end

local flattened_languages_to_install = flatten_languages(languages_to_install)

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
            ensure_installed = flattened_languages_to_install,
            automatic_installation = true -- Enable automatic installation of servers
        })
        mason_tool_installer.setup({
            ensure_installed = tools_to_install,
            automatic_installation = true -- Enable automatic installation of tools
        })
    end
}
