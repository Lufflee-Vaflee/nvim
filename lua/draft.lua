-- Function to run build command and capture output in quickfix
function build_to_qf(cmd, dir)
    cmd = cmd or config.build_command
    dir = dir or config.build_dir

    -- Change to build directory if specified
    local current_dir = vim.fn.getcwd()
    if dir ~= "" then
        vim.api.nvim_command("lcd " .. dir)
    end

    -- Run make command and populate quickfix
    vim.api.nvim_command("make! " .. cmd)

    -- Change back to original directory
    if dir ~= "" then
        vim.api.nvim_command("lcd " .. current_dir)
    end

    -- Get error count and handle quickfix window
    local qf_list = vim.fn.getqflist()
    handle_qf_window(#qf_list)

    return #qf_list
end

vim.keymap.set("n", "<leader>qb", build_to_qf(), { desc = "Build and capture in quickfix" })

-- Function to run static analyzer and capture output in quickfix
--function static_analyzer_to_qf(analyzer_name, custom_args)
--    local analyzer = config.static_analyzers[analyzer_name]
--    if not analyzer then
--        print("Unknown analyzer: " .. analyzer_name)
--        return 0
--    end
--
--    local args = custom_args or analyzer.args
--    local cmd = analyzer.command .. " " .. args
--
--    -- Set errorformat for this analyzer
--    vim.api.nvim_command("set errorformat=" .. analyzer.errorformat)
--
--    -- Run the command and capture output
--    vim.api.nvim_command("cexpr system('" .. cmd .. "')")
--
--    -- Restore default errorformat if needed
--    vim.api.nvim_command("set errorformat&")
--
--    -- Get error count and handle quickfix window
--    local qf_list = vim.fn.getqflist()
--    handle_qf_window(#qf_list)
--
--    return #qf_list
--end

--vim.keymap.set("n", "<leader>qa", function()
--    vim.ui.select(
--        vim.tbl_keys(config.static_analyzers),
--        { prompt = "Select static analyzer:" },
--        function(choice)
--            if choice then static_analyzer_to_qf(choice) end
--        end
--    )
--end, { desc = "Run static analyzer to quickfix" })

-- Completion configuration for Neovim using nvim-cmp, lsp-zero, and LuaSnip

--local lsp_zero = require('lsp-zero')
--local cmp = require('cmp')
--local cmp_action = lsp_zero.cmp_action()
--local luasnip = require('luasnip')
--
---- Helper function for super tab functionality (from lsp-zero docs)
--local has_words_before = function()
--  unpack = unpack or table.unpack
--  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
--end
--
---- Configure nvim-cmp
--cmp.setup({
--  -- Enable snippet support
--  snippet = {
--    expand = function(args)
--      luasnip.lsp_expand(args.body)
--    end,
--  },
--  
--  -- Configure window appearance
--  window = {
--    completion = cmp.config.window.bordered(),
--    documentation = cmp.config.window.bordered(),
--  },
--  
--  -- Set up completion sources (in priority order)
--  sources = cmp.config.sources({
--    { name = 'nvim_lsp' }, -- LSP
--    { name = 'luasnip' },  -- Snippets
--    { name = 'buffer' },   -- Text within current buffer
--    { name = 'path' },     -- File system paths
--  }),
--  
--  -- Configure key mappings
--  mapping = cmp.mapping.preset.insert({
--    -- Confirm selection
--    ['<CR>'] = cmp.mapping.confirm({ select = false }),
--    
--    -- Navigate between completion items
--    ['<C-p>'] = cmp.mapping.select_prev_item(),
--    ['<C-n>'] = cmp.mapping.select_next_item(),
--    
--    -- Scroll documentation
--    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
--    ['<C-d>'] = cmp.mapping.scroll_docs(4),
--    
--    -- Cancel completion
--    ['<C-e>'] = cmp.mapping.abort(),
--    
--    -- Navigate between snippet placeholders
--    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
--    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
--    
--    -- Super Tab functionality - provided by lsp-zero
--    ['<Tab>'] = cmp.mapping(function(fallback)
--      if cmp.visible() then
--        cmp.select_next_item()
--      elseif luasnip.expand_or_jumpable() then
--        luasnip.expand_or_jump()
--      elseif has_words_before() then
--        cmp.complete()
--      else
--        fallback()
--      end
--    end, { 'i', 's' }),
--    
--    ['<S-Tab>'] = cmp.mapping(function(fallback)
--      if cmp.visible() then
--        cmp.select_prev_item()
--      elseif luasnip.jumpable(-1) then
--        luasnip.jump(-1)
--      else
--        fallback()
--      end
--    end, { 'i', 's' }),
--  }),
--  
--  -- Formatting of completion items
--  formatting = {
--    format = function(entry, vim_item)
--      -- Set maximum width of completion details
--      local max_width = 50
--      if vim.fn.strwidth(vim_item.abbr) > max_width then
--        vim_item.abbr = string.sub(vim_item.abbr, 1, max_width) .. "..."
--      end
--      
--      -- Add source name to the right
--      vim_item.menu = ({
--        nvim_lsp = "[LSP]",
--        luasnip = "[Snippet]",
--        buffer = "[Buffer]",
--        path = "[Path]",
--      })[entry.source.name]
--      
--      return vim_item
--    end,
--  },
--})
--
---- Connect LSP to completion
--lsp_zero.on_attach(function(client, bufnr)
--    lsp_diagnostics_to_qf(
--  -- Additional custom keybindings for LSP can be added here
--  lsp_zero.default_keymaps({buffer = bufnr})
--  
--  -- Enable inlay hints if available
--  if client.server_capabilities.inlayHintProvider and vim.fn.has('nvim-0.10') == 1 then
--    vim.lsp.inlay_hint.enable(true)
--  end
--end)
--
---- Configure LSP capabilities
--local capabilities = require('cmp_nvim_lsp').default_capabilities()
--
---- Set up language servers (using mason-lspconfig)
--require('mason').setup({})
--require('mason-lspconfig').setup({
--  handlers = {
--    lsp_zero.default_setup,
--  },
--  ensure_installed = {
--    'lua_ls',
--    'clangd',
--    'gopls',
--  },
--})
--
---- Configure individual language servers if needed
--require('lspconfig').lua_ls.setup({
--  capabilities = capabilities,
--  settings = {
--    Lua = {
--      diagnostics = {
--        globals = { 'vim' } -- Recognize 'vim' as a global in lua
--      }
--    }
--  }
--})
--
---- Additional settings for nvim-cmp
---- Set completeopt to have a better completion experience
--vim.o.completeopt = 'menuone,noselect'
--
---- Avoid showing extra messages when using completion
--vim.opt.shortmess:append('c')
--
--print("LSP and completion configuration loaded")
