print("hello")

require("packerInit")

require("remaps")

require("common")
require("colors")

require("nvim-tree").setup()

require("TreeSitterInit")

require("LSP")

require("DAP")

require("finders")

require("line")

require("gitTools")

-- Setup diagnostics module for quickfix integration
require("diagnostics").setup({
    -- You can customize these options as needed
    auto_open_qflist = true,
    lsp_severity_filter = "error",
    build_command = "make",
    -- Add custom static analyzers if needed
})

require("diagnostics").setup_keymaps()
