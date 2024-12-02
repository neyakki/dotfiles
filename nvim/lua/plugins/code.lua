local lsp_languages = require("utils.const").lsp

-- https://github.com/neovim/nvim-lspconfig/tree/master
local lsp = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  -- TODO: Нужно вынести в отдельное место, иначе не работает Mason пока не откроем файл
  dependencies = {
    {
      "williamboman/mason.nvim",
      opts = {
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      },
    },
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = lsp_languages
      },
    }
  },
  config = function()
    local lspconfig = require("lspconfig")
    local keymap = vim.keymap.set

    -- LSP
    -- https //luals.github.io/wiki/settings
    lspconfig.lua_ls.setup({
      settings = {
        Lua = {
          telemetry = { enable = false },
          hint = { enable = true },
          hover = { enable = true },
          runtime = {
            version = "LuaJIT"
          }
        }
      }
    })
    lspconfig.pyright.setup {
      settings = {
        pyright = {
          -- Using Ruff's import organizer
          disableOrganizeImports = true,
        },
        python = {
          analysis = {
            -- Ignore all files for analysis to exclusively use Ruff for linting
            ignore = { '*' },
          },
        },
      },
    }
    -- Setup Ruff Linter
    lspconfig.ruff.setup {
      init_options = {
        settings = {
          -- Any extra CLI arguments for `ruff` go here.
          args = {
            "--select=E,F,UP,N,I,ASYNC,S,PTH",
            "--line-length=79",
            "--respect-gitignore", -- Исключать из сканирования файлы в .gitignore
            "--target-version=py311"
          },
        }
      }
    }

    -- HotKeys
    -- Global LSP mappings
    keymap("n", "<space>e", vim.diagnostic.open_float)
    keymap("n", "[d", vim.diagnostic.goto_prev)
    keymap("n", "]d", vim.diagnostic.goto_next)
    keymap("n", "<space>q", vim.diagnostic.setloclist)

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        local opts = { buffer = ev.buf }
        keymap("n", "lD", vim.lsp.buf.declaration, opts)
        keymap("n", "ld", vim.lsp.buf.definition, opts)
        keymap("n", "lk", vim.lsp.buf.hover, opts)
        keymap("n", "li", vim.lsp.buf.implementation, opts)
        keymap("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        keymap("n", "<space>D", vim.lsp.buf.type_definition, opts)
        keymap("n", "<space>rr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename Symbol" })
        keymap({ "n", "v" }, "<space>la", vim.lsp.buf.code_action, opts)
        keymap("n", "<space>lf", function()
          vim.lsp.buf.format({ async = true })
        end, opts)
      end,
    })
  end,
}

-- https://github.com/hrsh7th/nvim-cmp
local cmp = {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    {
      "onsails/lspkind.nvim",
      opt = {
        -- https://github.com/onsails/lspkind.nvim
        symbol_map = {
          Text = "󰉿",
          Method = "󰆧",
          Function = "󰊕",
          Constructor = "",
          Field = "󰜢",
          Variable = "󰀫",
          Class = "󰠱",
          Interface = "",
          Module = "",
          Property = "󰜢",
          Unit = "󰑭",
          Value = "󰎠",
          Enum = "",
          Keyword = "󰌋",
          Snippet = "",
          Color = "󰏘",
          File = "󰈙",
          Reference = "󰈇",
          Folder = "󰉋",
          EnumMember = "",
          Constant = "󰏿",
          Struct = "󰙅",
          Event = "",
          Operator = "󰆕",
          TypeParameter = "",
        },
      },
    },
    "lukas-reineke/cmp-under-comparator",
    {
      "L3MON4D3/LuaSnip",
      dependencies = {
        "rafamadriz/friendly-snippets",
      },
      build = "make install_jsregexp",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load({
          include = { "lua", "python" },
          paths = { "/home/neyakki/.config/nvim/snippets/" }
        })
      end
    },
    "saadparwaiz1/cmp_luasnip",
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local cmp = require 'cmp'
    local lspkind = require("lspkind")

    cmp.setup({
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
      }),
      sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          -- cmp.config.compare.scopes,
          require("cmp-under-comparator").under,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          -- cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      enabled = function()
        -- disable completion in comments
        local context = require("cmp.config.context")

        -- keep command mode completion enabled
        if vim.api.nvim_get_mode().mode == "c" then
          return true
        else
          return not context.in_treesitter_capture("comment")
              and not context.in_syntax_group("Comment")
        end
      end,
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "...",
          menu = {
            buffer = "[Buffer]",
            nvim_lsp = "[LSP]",
            luasnip = "[LuaSnip]",
            path = "[PTH]",
            zsh = "[ZSH]",
          },
        }),
      },
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources(
        { { name = 'path' } },
        { { name = 'cmdline' } }
      ),
      matching = { disallow_symbol_nonprefix_matching = false }
    })

    -- Set up lspconfig.
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
    require('lspconfig').lua_ls.setup {
      capabilities = capabilities
    }
    require('lspconfig').ruff.setup {
      capabilities = capabilities
    }
    require('lspconfig').pyright.setup {
      capabilities = capabilities
    }
  end
}

return {
  lsp,
  cmp,
}
