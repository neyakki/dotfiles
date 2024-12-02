local telescope = {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { "xiyaowong/telescope-emoji.nvim" },
  },
  opts = {
    defaults = {
      prompt_prefix = "🔍 ", -- Префикс в строке поиска
      selection_caret = "➤ ", -- Указатель на выбранный элемент
      path_display = { "smart" }, -- Отображение путей файлов
      sorting_strategy = "ascending", -- Сортировка результатов
      layout_strategy = "flex", -- Адаптивное расположение
      layout_config = {
        horizontal = { preview_width = 0.6 },
        vertical = { preview_height = 0.7 },
      },
    },
    pickers = {
      find_files = {
        theme = "dropdown",
      },
      live_grep = {
        theme = "ivy", -- Использование темы "ivy"
      },
    },
  }
}

return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true,  -- show icons in the signs column
      sign_priority = 8, -- sign priority
      -- keywords recognized as todo comments
      keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      },
      merge_keywords = true, -- when true, custom keywords will be merged with the defaults
      -- highlighting of the line containing the todo comment
      -- * before: highlights before the keyword (typically comment characters)
      -- * keyword: highlights of the keyword
      -- * after: highlights after the keyword (todo text)
      highlight = {
        before = "",                 -- "fg" or "bg" or empty
        keyword = "wide",            -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
        after = "fg",                -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
        comments_only = true,        -- uses treesitter to match keywords in comments only
        max_line_len = 400,          -- ignore lines longer than this
        exclude = {},                -- list of file types to exclude highlighting
      },
      -- list of named colors where we try to extract the guifg from the
      -- list of hilight groups or use the hex color if hl not found as a fallback
      colors = {
        error = { "LspDiagnosticsDefaultError", "ErrorMsg", "#DC2626" },
        warning = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#FBBF24" },
        info = { "LspDiagnosticsDefaultInformation", "#2563EB" },
        hint = { "LspDiagnosticsDefaultHint", "#10B981" },
        default = { "Identifier", "#7C3AED" },
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
      },
    }
  },
  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
    },
    lazy = false,
  },
  telescope,
  {
    "m4xshen/autoclose.nvim",
    opts = {
      options = {
        disabled_filetypes = { "text" },
        disable_when_touch = true,
        pair_spaces = true,
      },
      keys = {
        ["'"] = {
          escape = true,
          close = true,
          pair = "''",
          disabled_filetypes = { "markdown" },
        },
        ["`"] = { escape = false, close = true, pair = "``" },
        [">"] = { escape = false, close = false, pair = "><" },
      },
    },
  },
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      local terminal = require("toggleterm")
      terminal.setup({
        size = function(term) -- 25,
          if term.direction == "horizontal" then
            return 20
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.3
          end
        end,
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>exit<CR>", { noremap = true, silent = true })
        end,
      })
      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit  = Terminal:new({
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        float_opts = {
          border = "double",
        },
      })

      function _lazygit_toggle()
        lazygit:toggle()
      end

      local temp_term = Terminal:new({
        hidden = true,
        direction = "vertical",
        dir = "/tmp/",
      })

      function _term_toggle()
        temp_term:toggle()
      end

      vim.keymap.set('t', 'q', [[<C-\><C-n>]], {})
      vim.api.nvim_set_keymap("n", "<leader>tg", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", {})
      vim.keymap.set("n", "<leader>tt", "<cmd>lua _term_toggle()<CR>", {})
    end
  }
}
