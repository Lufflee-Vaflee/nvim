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
require("diagnostics")

require("diagnostics").setup_keymaps()
