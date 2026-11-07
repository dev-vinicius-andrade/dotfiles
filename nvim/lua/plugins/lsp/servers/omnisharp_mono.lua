return {
    cmd = {"omnisharp", "--languageserver"},
    filetypes = {"csharp"},
    root_markers = { "*.sln", "*.csproj", ".git" },
    settings = {
        omnisharp = {
            intellisense = {
                enableImportCompletion = true,
                enableMsBuildLoadProjectsOnDemand = true
            }
        }
    }
}
