function ColorMyPencils()
    vim.cmd.colorscheme("arctic")

    --semantic highlight
    vim.highlight.priorities.semantic_tokens = 85

    vim.opt.cursorline = true

    vim.api.nvim_set_hl(0, "CursorLine", {bg = '#2a2d2e'} )

    vim.fn.sign_define('DapBreakpoint', {
        text='🛑',
        texthl='',
        linehl='',
        numhl=''
    })

    vim.api.nvim_set_hl(0, "DapLine", { bg = '#002936' } )

    vim.fn.sign_define('DapStopped',
    {
        text=' ', -- nerdfonts icon here
        texthl='',
        linehl='DapLine',
        numhl=''
    })

end

ColorMyPencils()

