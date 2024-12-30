print("Hello from TreeSitter init")

require("nvim-tree").setup()

require("nvim-treesitter.configs").setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = {
        "c",
        "cpp",
        "asm",
        "python",

        "ninja",
        "make",
        "cmake",
        "bash",

        "json",
        "xml",
        "proto",

        "lua",
        "vim",
        "vimdoc",
        "query"
    },

    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

