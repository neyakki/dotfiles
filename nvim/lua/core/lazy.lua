-- https://lazy.folke.io/
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
    -- THEMES
		require("plugins.ui"),
		require("themes.onedark"),
		require("themes.catpuccin"),
		-- CORE
		require("plugins.nvimtree"),
		require("plugins.treesiter"),
		require("plugins.which-key"),
    -- CODE
		require("plugins.code"),
		require("plugins.database"),
    -- TOOLS
		require("plugins.tools"),
},
	checker = { enabled = true },
})

vim.api.nvim_create_autocmd('VimLeave', {
    callback = function()
        if #vim.api.nvim_list_bufs() == 0 then  -- Если нет открытых буферов
            -- Открываем dashboard
            vim.cmd('Alpha')
        end
    end
})
