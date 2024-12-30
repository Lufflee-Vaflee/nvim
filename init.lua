print("hello")

require("packerInit")

require("remaps")

require("common")
require("colors")

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.fillchars:append { eob = " " }
vim.g.loaded_matchparen = true

require("nvim-tree").setup()

require("TreeSitterInit")

require("LSP")

require("finders")

