local g = vim.g
local opt = vim.opt
local wo = vim.wo

-- Base
g.mapleader = " "
opt.modelines = 0
opt.timeoutlen = 300
opt.undofile = true
opt.shell = "/bin/zsh"
opt.swapfile = false
opt.scrolloff = 8
opt.wrap = true
opt.termguicolors = true
opt.cmdheight = 1

-- Line Numbers
wo.number = true
wo.relativenumber = true

-- Mouse
opt.mouse = ""
opt.mousefocus = false

-- Clipboard
opt.clipboard = "unnamedplus"

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
-- Disable message about change file
opt.shortmess:append("c")

-- Indent Settings
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.smarttab = true
opt.smartindent = true

-- fuzzy find
opt.path:append("**")
-- lazy file name tab completion
-- opt.wildmode = "list:longest,list:full"
opt.wildmenu = true
opt.wildignorecase = true
-- ignore files vim doesnt use
opt.wildignore:append(".git,.hg,.svn")
opt.wildignore:append(".aux,*.out,*.toc")
opt.wildignore:append(".o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class")
opt.wildignore:append(".ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp")
opt.wildignore:append(".avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg")
opt.wildignore:append(".mp3,*.oga,*.ogg,*.wav,*.flac")
opt.wildignore:append(".eot,*.otf,*.ttf,*.woff")
opt.wildignore:append(".doc,*.pdf,*.cbr,*.cbz")
opt.wildignore:append(".zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb")
opt.wildignore:append(".swp,.lock,.DS_Store,._*")
opt.wildignore:append(".,..")

-- Fillchars
opt.fillchars = {
  vert = "│",
  fold = "⠀",
  eob = " ", -- suppress ~ at EndOfBuffer
  -- diff = "⣿", -- alternatives = ⣿ ░ ─ ╱
  msgsep = "‾",
  foldopen = "▾",
  foldsep = "│",
  foldclose = "▸",
}
