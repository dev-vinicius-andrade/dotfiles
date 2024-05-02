return {
    "gbprod/substitute.nvim",
    event = {"BufReadPre", "BufNewFile"},
    config = function()
        local substitute = require("substitute")

        substitute.setup()
    end
}
