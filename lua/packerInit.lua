print("Hello form packer")

-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Only required if you have packer configured as `opt` vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use { 'wbthomason/packer.nvim' }

    use { 'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons',
        },
    }

    use {
        'nvim-telescope/telescope.nvim', branch = '0.1.x',
        requires = {{
            'nvim-lua/plenary.nvim'
        }}
    }

    use {
        "rockyzhang24/arctic.nvim",
        branch = 'v2',
        requires = {
            "rktjmp/lush.nvim"
        }
    }

    use (
        'nvim-treesitter/nvim-treesitter', {
        run = ':TSUpdate'
    })

    use {
        'HiPhish/rainbow-delimiters.nvim'
    }

    use {
        'williamboman/mason.nvim',
        opts = {
            ensure_installed = {
                "clangd",
                "cmake-language-server",
                "gopls",
                "lua-language-server",
                "codelldb"
            }
        }
    }

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            {'neovim/nvim-lspconfig'},
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'L3MON4D3/LuaSnip'},
        }
    }

    use {
        "mfussenegger/nvim-dap",
        requires = {
            "williamboman/mason.nvim",
        }
    }

    use {
        "rcarriga/nvim-dap-ui",
        requires = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        }
    }

    use {
        'nvim-lualine/lualine.nvim',
        requires = {
            'nvim-tee/nvim-web-devicons',
            opt = true
        }
    }

    use {
        'Lufflee-Vaflee/gitgraph.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'sindrets/diffview.nvim'
        }
    }

    use {
        'lewis6991/gitsigns.nvim'
    }

end)
