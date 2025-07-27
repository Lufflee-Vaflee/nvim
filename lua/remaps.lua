vim.g.mapleader = " "

vim.keymap.set("n", "<leader>t", vim.cmd.NvimTreeToggle)

vim.keymap.set("n", "<leader>h", "<C-W>h")
vim.keymap.set("n", "<leader>j", "<C-W>j")
vim.keymap.set("n", "<leader>k", "<C-W>k")
vim.keymap.set("n", "<leader>l", "<C-W>l")

vim.keymap.set("n", "<leader>wq", "<cmd>q<CR>")

-- Paste without replacing clipboard register
vim.keymap.set("x", "<leader>p", [=["_dP]=])
vim.keymap.set({"n", "v"}, "<leader>d", [=["_d]=])

-- Alternative paste mappings that preserve register
vim.keymap.set("x", "p", [=["_dP]=])
vim.keymap.set("x", "P", [=["_dP]=])

