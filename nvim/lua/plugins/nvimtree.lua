-- https://github.com/nvim-tree/nvim-tree.lua
return {
    'nvim-tree/nvim-tree.lua',
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
        {
            "<leader>nf",
            function()
                vim.cmd([[ NvimTreeToggle ]])
            end,
            desc = "Toggle NvimTree"
        },
        {
            "<leader>n",
            function()
                vim.cmd([[ NvimTreeFocus ]])
            end,
            desc = "Focus NvimTree"
        }

    }
}
