print("Hello from remap")

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>t", vim.cmd.NvimTreeToggle)
vim.keymap.set("n", "<leader>u", ":u<cr>")
vim.keymap.set("n", "<leader>w", "<C-W>")

