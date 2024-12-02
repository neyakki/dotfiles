-- tab format for .lua file
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.lua" },
  callback = function()
    vim.opt.shiftwidth = 2
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
  end,
})
