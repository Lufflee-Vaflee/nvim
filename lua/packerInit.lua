print("Hello form packer")

-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons',
        },
    }

    use {
        'nvim-telescope/telescope.nvim', branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use {
        "rockyzhang24/arctic.nvim",
        branch = 'v2',
        requires = { "rktjmp/lush.nvim" }
    }

    use 'freddiehaddad/feline.nvim'

    use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

    use { 'HiPhish/rainbow-delimiters.nvim' }

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
end)

