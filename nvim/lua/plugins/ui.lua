-- https://github.com/mrjones2014/smart-splits.nvim
local colors = {
    bg       = '#202328',
    fg       = '#bbc2cf',
    yellow   = '#ECBE7B',
    cyan     = '#008080',
    darkblue = '#081633',
    green    = '#98be65',
    orange   = '#FF8800',
    violet   = '#a9a1e1',
    magenta  = '#c678dd',
    blue     = '#51afef',
    red      = '#ec5f67',
    gray     = "#585b70",
}

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand('%:p:h')
        local gitdir = vim.fn.finddir('.git', filepath .. ';')
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
}

return {
   {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = function(_, opts)
            opts.options = {
                -- Disable sections and component separators
                component_separators = '',
                section_separators = '',
                theme = {
                    -- We are going to use lualine_c an lualine_x as left and
                    -- right section. Both are highlighted by c theme .  So we
                    -- are just setting default looks o statusline
                    normal = { c = { fg = colors.fg, bg = colors.bg } },
                    inactive = { c = { fg = colors.fg, bg = colors.bg } },
                },
            }
            opts.sections = {
                -- these are to remove the defaults
                lualine_a = {},
                lualine_b = {},
                lualine_y = {},
                lualine_z = {},
                -- These will be filled later
                lualine_c = {
                    {
                        function()
                            return '▊'
                        end,
                        color = { fg = colors.blue },      -- Sets highlighting of component
                        padding = { left = 0, right = 1 }, -- We don't need space before this
                    },
                    {
                        -- mode component
                        function()
                            return ''
                        end,
                        color = function()
                            -- auto change color according to neovims mode
                            local mode_color = {
                                n = colors.red,
                                i = colors.green,
                                v = colors.blue,
                                [''] = colors.blue,
                                V = colors.blue,
                                c = colors.magenta,
                                no = colors.red,
                                s = colors.orange,
                                S = colors.orange,
                                [''] = colors.orange,
                                ic = colors.yellow,
                                R = colors.violet,
                                Rv = colors.violet,
                                cv = colors.red,
                                ce = colors.red,
                                r = colors.cyan,
                                rm = colors.cyan,
                                ['r?'] = colors.cyan,
                                ['!'] = colors.red,
                                t = colors.orange,
                            }
                            return { fg = mode_color[vim.fn.mode()] }
                        end,
                        padding = { right = 1 },
                    },
                    {
                        'filesize',
                        cond = conditions.buffer_not_empty,
                    },
                    {
                        'filename',
                        cond = conditions.buffer_not_empty,
                        color = { fg = colors.magenta, gui = 'bold' },
                    },
                    { 'location' },
                    {
                        'progress',
                        color = { fg = colors.fg, gui = 'bold' }
                    },
                    {
                        'diagnostics',
                        sources = { 'nvim_diagnostic' },
                        symbols = { error = ' ', warn = ' ', info = ' ' },
                        diagnostics_color = {
                            error = { fg = colors.red },
                            warn = { fg = colors.yellow },
                            info = { fg = colors.cyan },
                        },
                    },
                    {
                        function()
                            return '%='
                        end,
                    },
                    {
                        function()
                            local msg = 'No Active Lsp'
                            local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
                            local clients = vim.lsp.get_clients()
                            if next(clients) == nil then
                                return msg
                            end
                            for _, client in ipairs(clients) do
                                local filetypes = client.config.filetypes
                                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                                    return client.name
                                end
                            end
                            return msg
                        end,
                        icon = ' LSP:',
                        color = { fg = '#ffffff', gui = 'bold' },
                    }
                },
                lualine_x = {
                    {
                        'o:encoding',       -- option component same as &encoding in viml
                        fmt = string.upper, -- I'm not sure why it's upper case either ;)
                        cond = conditions.hide_in_width,
                        color = { fg = colors.green, gui = 'bold' },
                    },
                    {
                        'fileformat',
                        fmt = string.upper,
                        icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
                        color = { fg = colors.green, gui = 'bold' },
                    },
                    {
                        'branch',
                        icon = '',
                        color = { fg = colors.violet, gui = 'bold' },
                    },
                    {
                        'diff',
                        -- Is it me or the symbol for modified us really weird
                        symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
                        diff_color = {
                            added = { fg = colors.green },
                            modified = { fg = colors.orange },
                            removed = { fg = colors.red },
                        },
                        cond = conditions.hide_in_width,
                    },
                    {
                        function()
                            return '▊'
                        end,
                        color = { fg = colors.blue },
                        padding = { left = 1 },
                    },
                },
            }
            opts.inactive_sections = {
                -- these are to remove the defaults
                lualine_a = {},
                lualine_b = {},
                lualine_y = {},
                lualine_z = {},
                lualine_c = {},
                lualine_x = {},
            }
        end
    },
    {
        "akinsho/bufferline.nvim",
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = {
            options = {
                separator_style = "slant",
                mode = "buffers",
                numbers = "none",
                unique_names = true,
                color_icons = true,
                indicator = {
                    style = "none",
                },
                modified_icon = "●",
                left_trunc_marker = "",
                right_trunc_marker = "",
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    local s = " "
                    for e, _ in pairs(diagnostics_dict) do
                        local sym = e == "error" and " " or (e == "warning" and " " or " ")
                        s = s .. sym
                    end
                    return s
                end,
                always_show_bufferline = true,
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = " File Explorer",
                        highlight = "Directory",
                        text_align = "left",
                        separator = false,
                    },
                },
            },
            highlights = {
                background = {
                    fg = colors.gray,
                },
                buffer_selected = {
                    fg = colors.cyan,
                },
                buffer_visible = {
                    fg = colors.gray,
                },
                separator = {
                    bg = "#1e1e2e",
                    fg = "#1e1e2e",
                },
                diagnostic = {},
            }
        },
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },
            presets = {
                bottom_search = false,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = false,
                lsp_doc_border = false,
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            {
                "rcarriga/nvim-notify",
                keys = {
                    {
                        "<leader>un",
                        function()
                            require("notify").dismiss({ silent = true, pending = true })
                        end,
                        desc = "Dismiss All Notifications",
                    },
                },
                opts = {
                    stages = "static",
                    timeout = 3000,
                    icons = {
                        ERROR = "",
                        WARN = "",
                        INFO = "",
                        DEBUG = "",
                        TRACE = "✎",
                    },
                    top_down = false,
                    max_height = function()
                        return math.floor(vim.o.lines * 0.75)
                    end,
                    max_width = function()
                        return math.floor(vim.o.columns * 0.75)
                    end,
                    on_open = function(win)
                        vim.api.nvim_win_set_config(win, { zindex = 100 })
                    end,
                }
            },
        }
    },
    {
        'goolord/alpha-nvim',
        dependencies = {
            'echasnovski/mini.icons',
            'nvim-lua/plenary.nvim'
        },
        config = function()
            require 'alpha'.setup(require 'alpha.themes.theta'.config)
        end
    }
}
