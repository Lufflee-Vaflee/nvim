print("Hello from common settings")

vim.opt.nu = true
vim.opt.relativenumber = true

vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

vim.opt.listchars = {
    space = '·',
    tab = '→→'
}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.loaded_matchparen = true

vim.opt.list = true

vim.opt.smartindent = true;

vim.opt.wrap = false

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 30
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.fillchars:append { eob = " " }
vim.g.loaded_matchparen = true


