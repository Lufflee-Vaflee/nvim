vim.api.nvim_set_hl(0, "DiffTextChanged", { fg =0x1F58AE,  link = "DiffLineChanged" } )

vim.opt.fillchars:append { eob = " ", diff = "╱"}

-- Make diff symbols less bright
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        -- Soften the diff delete (DiffDelete) color
        vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#5a5a5a", link="DiffLineDelete" })
    end,
})
