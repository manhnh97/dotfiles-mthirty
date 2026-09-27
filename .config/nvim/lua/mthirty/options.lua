local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.termguicolors = true
opt.updatetime = 200
opt.timeoutlen = 300
opt.ttimeoutlen = 10
opt.undofile = true
opt.swapfile = false
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 8
opt.cursorline = true
opt.wrap = false
opt.inccommand = "split"
opt.grepprg = "rg --vimgrep --smart-case"
opt.mouse = ""

vim.g.mapleader = " "
vim.g.maplocalleader = " "
