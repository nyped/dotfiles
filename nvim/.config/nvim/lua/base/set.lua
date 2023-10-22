vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.title = true
vim.opt.titlestring = "nvim [1m%t%m "

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4

vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.cursorcolumn = true
vim.opt.cursorline = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wrap = false
vim.opt.sidescroll = 5

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.mouse = "nv"

vim.opt.shortmess = "FWSsa"

vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 90
vim.opt.foldmethod = "expr"

vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"

vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
