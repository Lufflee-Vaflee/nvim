-- Completion configuration for Neovim using nvim-cmp, lsp-zero, and LuaSnip

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local luasnip = require('luasnip')

-- Helper function for super tab functionality (from lsp-zero docs)
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Configure nvim-cmp
cmp.setup({
  -- Enable snippet support
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  -- Configure window appearance
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  -- Set up completion sources (in priority order)
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- LSP
    { name = 'luasnip' },  -- Snippets
    { name = 'buffer' },   -- Text within current buffer
    { name = 'path' },     -- File system paths
  }),

  -- Configure key mappings
  mapping = cmp.mapping.preset.insert({
    -- Confirm selection
    ['<CR>'] = cmp.mapping.confirm({ select = false }),

    -- Navigate between completion items
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),

    -- Scroll documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),

    -- Cancel completion
    ['<C-e>'] = cmp.mapping.abort(),

    -- Navigate between snippet placeholders
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),

    -- Super Tab functionality - provided by lsp-zero
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),

  -- Formatting of completion items
  formatting = {
    format = function(entry, vim_item)
      -- Set maximum width of completion details
      local max_width = 30
      if vim.fn.strwidth(vim_item.abbr) > max_width then
        vim_item.abbr = string.sub(vim_item.abbr, 1, max_width) .. "..."
      end

      -- Add source name to the right
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]

      return vim_item
    end,
  },
})

-- Additional settings for nvim-cmp
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Avoid showing extra messages when using completion
vim.opt.shortmess:append('c')

print("LSP and completion configuration loaded")
