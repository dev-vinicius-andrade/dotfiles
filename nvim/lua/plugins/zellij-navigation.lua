return {
    "dynamotn/Navigator.nvim",
    event = "VeryLazy",
    config = function()
        require("Navigator").setup()
    end
}
