return {
    cmd = {"omnisharp", "--languageserver"},
    filetypes = {"csharp"},
    root_dir = require("lspconfig.util").root_pattern("*.sln", "*.csproj", ".git"),
    settings = {
        omnisharp = {
            intellisense = {
                enableImportCompletion = true,
                enableMsBuildLoadProjectsOnDemand = true
            }
        }
    }
}
