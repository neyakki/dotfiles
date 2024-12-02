function nm(key, cmd, opt)
  vim.keymap.set("n", key, cmd, opt)
end

-- Copy/Paste
nm("<leader>y", '"*y<CR>', { desc = "Copying to a shared buffer" })
nm("<leader>p", '"*p<CR>', { desc = "Inserting from a shared buffer" })

-- TODO: Хз почему, но маппинг работает только отсюда
local builtin = require('telescope.builtin')
-- Работа с файлами и буфферами
vim.keymap.set('n', '<leader>f', function() end, { desc = "Find" })
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find File" })
vim.keymap.set('n', '<leader>ft', builtin.live_grep, { desc = "Find Text" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find Buffer" })

-- Выбор цветовой схемы
vim.keymap.set('n', '<leader>cs', builtin.colorscheme, { desc = "Choose Colorscheme" })

-- BufferLine
vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', { desc = "Go next tab" })
vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { desc = "Prev next tab" })
vim.keymap.set("n", "<leader>x", ":BufferLinePickClose<CR>", { desc = "Pick tab close" })
vim.keymap.set('n', '<C-x>', ':BufferLineCloseOthers<CR>', { desc = "Close other" })

-- TodoList
vim.keymap.set('n', '<leader>nl', ':TodoTelescope<CR>')
