local lsp = require("lsp-zero")
lsp.preset("recommended")

local on_lua_init = function (client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
        return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
            version = 'LuaJIT'
        },
        workspace = {
            checkThirdParty = false,
            library = {
                vim.env.VIMRUNTIME
            }
        },
    })
end

require('mason').setup({})
require('mason-lspconfig').setup({
    -- Replace the language servers listed here 
    -- with the ones you want to install
    ensure_installed = {"clangd", "lua_ls", "cmake"},
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup{}
        end,
        ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup{
                on_init = on_lua_init,
                settings = {
                    Lua = {}
                }
            }
        end
    },
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' } -- Recognize 'vim' as a global in lua
            }
        }
    }
})

lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({buffer = bufnr})

    if client.server_capabilities.inlayHintProvider and vim.fn.has('nvim-0.10') == 1 then
        vim.lsp.inlay_hint.enable(true)
    end
end)

