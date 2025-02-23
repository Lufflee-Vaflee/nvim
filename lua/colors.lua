print("hello from colors")

local rainbow_delimiters = require 'rainbow-delimiters'
function ColorMyPencils()
    vim.cmd.colorscheme("arctic")

    --semantic highlight
    vim.highlight.priorities.semantic_tokens = 105

    --semantic highlight for mutable variables
    vim.api.nvim_set_hl(0, "@lsp.type.property", { fg = '#F9F92D' } )
    vim.api.nvim_set_hl(0, "@lsp.typemod.variable.globalScope.cpp", { fg = '#F51A12' } )
    vim.api.nvim_set_hl(0, "@lsp.typemod.class.defaultLibrary.cpp", { link = '@type.class' } )
    vim.api.nvim_set_hl(0, "@lsp.mod.static.cpp", { fg = '#9136EB' } )

    --semantic highlight for parameterization
    vim.api.nvim_set_hl(0, "@lsp.type.typeParameter.cpp", { fg = '#C586C0' } )

    --constants highlighting(overrides mutable ones)
    vim.api.nvim_set_hl(0, "@lsp.type.macro.cpp", { fg = '#00FFE2' } )
    --clear hg group for static with higher priority allowing readonly to override it
    vim.api.nvim_set_hl(0, "@lsp.typemod.variable.static.cpp", {} )
    vim.api.nvim_set_hl(0, "@lsp.typemod.variable.readonly.cpp", { fg = '#00FFE2' } )
    vim.api.nvim_set_hl(0, "@lsp.typemod.property.readonly.cpp", { fg = '#00FFE2' } )
    vim.api.nvim_set_hl(0, "@lsp.typemod.parameter.readonly.cpp", { fg = '#00FFE2' } )
    vim.api.nvim_set_hl(0, "@lsp.typemod.typeParameter.readonly.cpp", { fg = '#00FFE2' } )



    --additional highlight for operators
    vim.api.nvim_set_hl(0, "@lsp.type.operator.cpp", { fg = '#DA70D6' } )

    --highlight groups for "rainbow brackets"
    vim.api.nvim_set_hl(0, "DelimeterYellow", { fg = '#FFD700' } )
    vim.api.nvim_set_hl(0, "DelimeterPink", { fg = '#DA70D6' } )
    vim.api.nvim_set_hl(0, "DelimeterBlue", { fg = '#179FFF' } )


    vim.g.rainbow_delimiters = {
    strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        vim = rainbow_delimiters.strategy['local'],
    },
    query = {
        [''] = 'rainbow-delimiters',
    },
    priority = {
        [''] = 110,
        lua = 210,
    },
    highlight = {
        'DelimeterYellow',
        'DelimeterPink',
        'DelimeterBlue',
    },
    }

    vim.fn.sign_define('DapBreakpoint', {
        text='🛑',
        texthl='',
        linehl='',
        numhl=''
    })

    vim.api.nvim_set_hl(0, "DapLine", { bg = '#070707' } )

    vim.fn.sign_define('DapStopped',
    {
        text='🔴', -- nerdfonts icon here
        texthl='',
        linehl='DapLine',
        numhl=''
    })

end

ColorMyPencils()

