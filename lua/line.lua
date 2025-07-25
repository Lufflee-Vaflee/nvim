vim.api.nvim_set_hl(0, "StatusLine", { bg = nil } )
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = nil } )
vim.api.nvim_set_hl(0, "NvimTreeStatusLine", { bg = nil } )
vim.api.nvim_set_hl(0, "NvimTreeStatusLineNC", { bg = nil } )

local colors = {
    gray     = '#3C3C3C',
    lightred = '#D16969',
    blue     = '#569CD6',
    pink     = '#C586C0',
    black    = '#262626',
    white    = '#D4D4D4',
    green    = '#608B4E',
}

local line_theme = {
    normal = {
        b = { fg = colors.green, bg = colors.black },
        a = { fg = colors.black, bg = colors.green, gui = 'bold' },
        c = { fg = colors.white, bg = nil },
    },
    visual = {
        b = { fg = colors.pink, bg = colors.black },
        a = { fg = colors.black, bg = colors.pink, gui = 'bold' },
        c = { fg = colors.pink, bg = nil}
    },
    inactive = {
        b = { fg = colors.black, bg = colors.blue },
        a = { fg = colors.white, bg = colors.gray, gui = 'bold' },
    },
    replace = {
        b = { fg = colors.lightred, bg = colors.black },
        a = { fg = colors.black, bg = colors.lightred, gui = 'bold' },
        c = { fg = colors.white, bg = nil },
    },
    insert = {
        b = { fg = colors.blue, bg = colors.black },
        a = { fg = colors.black, bg = colors.blue, gui = 'bold' },
        c = { fg = colors.blue, bg = nil },
    },
}

require('lualine').setup {
    options = {
        theme = line_theme,
    },
    extensions = {
        "nvim-tree"
    },
    sections = {
      lualine_c = {
        {
          'filename',
          file_status = true, -- displays file status (readonly status, modified status)
          path = 2 -- 0 = just filename, 1 = relative path, 2 = absolute path
        }
      }
    }
}

