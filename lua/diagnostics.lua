local M = {}

-- Configuration options with default values
local config = {
    -- Basic options
    auto_open_qflist = true,         -- Auto-open quickfix after collecting diagnostics
    auto_close_qflist = false,       -- Auto-close quickfix when no errors
    focus_qflist = true,             -- Focus quickfix window after opening

    -- LSP diagnostic options
    lsp_severity_filter = "error",    -- Filter by minimum severity (error, warning, info, hint)

    -- Build command options
    build_command = "make",          -- Default build command
    build_dir = "",                  -- Default build directory (empty = cwd)

    -- Common static analyzers with their output parsing format
    static_analyzers = {
        clang_tidy = {
            command = "clang-tidy",
            args = "*.cpp -- -std=c++17",
            errorformat = "%f:%l:%c: %trror: %m,%f:%l:%c: %tarning: %m,%f:%l:%c: %tote: %m"
        },
        cppcheck = {
            command = "cppcheck",
            args = "--enable=all --xml --xml-version=2 .",
            errorformat = "%f:%l:%c: %trror: %m,%f:%l:%c: %tarning: %m,%f:%l:%c: %tote: %m"
        }
    }
}

-- Set configuration options
function M.setup(user_config)
    config = vim.tbl_deep_extend("force", config, user_config or {})
end

-- Convert LSP diagnostics severity to quickfix type
local function severity_to_type(severity)
    local types = { "E", "W", "I", "N" }
    return types[severity] or "E"
end

-- Function to collect LSP diagnostics and put them in quickfix
function M.lsp_diagnostics_to_qf()
    -- Add a debug print
    print("Running lsp_diagnostics_to_qf function...")

    -- Get all diagnostics
    local diagnostics = vim.diagnostic.get(nil)

    -- Print raw diagnostics count and severity info
    print("Raw diagnostics count: " .. #diagnostics)

    -- Convert diagnostics to quickfix items - TEMPORARILY REMOVE SEVERITY FILTER
    local qf_items = {}
    for _, diagnostic in ipairs(diagnostics) do
        -- Remove the severity filter condition
        table.insert(qf_items, {
            filename = vim.api.nvim_buf_get_name(diagnostic.bufnr),
            lnum = diagnostic.lnum + 1,  -- LSP uses 0-based, quickfix uses 1-based
            col = diagnostic.col + 1,    -- LSP uses 0-based, quickfix uses 1-based
            text = diagnostic.message,
            type = severity_to_type(diagnostic.severity)
        })
    end

    -- Print the count of found diagnostics
    print("Found " .. #qf_items .. " diagnostics (with no severity filter)")

    -- Populate quickfix list
    vim.fn.setqflist(qf_items, 'r')

    -- Handle quickfix window
    M.handle_qf_window(#qf_items)

    return #qf_items
end

-- Function to run a build command and capture output in quickfix
function M.build_to_qf(cmd, dir)
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
    M.handle_qf_window(#qf_list)
   
    return #qf_list
end

-- Function to run static analyzer and capture output in quickfix
function M.static_analyzer_to_qf(analyzer_name, custom_args)
    local analyzer = config.static_analyzers[analyzer_name]
    if not analyzer then
        print("Unknown analyzer: " .. analyzer_name)
        return 0
    end

    local args = custom_args or analyzer.args
    local cmd = analyzer.command .. " " .. args

    -- Set errorformat for this analyzer
    vim.api.nvim_command("set errorformat=" .. analyzer.errorformat)

    -- Run the command and capture output
    vim.api.nvim_command("cexpr system('" .. cmd .. "')")

    -- Restore default errorformat if needed
    vim.api.nvim_command("set errorformat&")

    -- Get error count and handle quickfix window
    local qf_list = vim.fn.getqflist()
    M.handle_qf_window(#qf_list)

    return #qf_list
end

-- Helper function to open/close quickfix window based on config
function M.handle_qf_window(count)
    if count > 0 then
        if config.auto_open_qflist then
            vim.api.nvim_command("copen")
            if config.focus_qflist then
                vim.api.nvim_command("wincmd J") -- Move to bottom
            end
        end
    else
        if config.auto_close_qflist then
            vim.api.nvim_command("cclose")
        end
    end
end

-- Function to toggle the quickfix window
function M.toggle_quickfix()
    local qf_win = vim.fn.getqflist({winid = 0}).winid
    if qf_win == 0 then
        vim.api.nvim_command("copen")
        vim.api.nvim_command("wincmd J") -- Move to bottom
    else
        vim.api.nvim_command("cclose")
    end
end

-- Setup default keymaps
function M.setup_keymaps()
    -- These are in addition to the ones you already have (<M-j>, <M-k>, <M-q>)
    vim.keymap.set("n", "<leader>qf", M.toggle_quickfix, { desc = "Toggle quickfix window" })
    vim.keymap.set("n", "<leader>qd", M.lsp_diagnostics_to_qf, { desc = "LSP diagnostics to quickfix" })
    vim.keymap.set("n", "<leader>qb", function() M.build_to_qf() end, { desc = "Build and capture in quickfix" })
    vim.keymap.set("n", "<leader>qa", function()
        vim.ui.select(
            vim.tbl_keys(config.static_analyzers),
            { prompt = "Select static analyzer:" },
            function(choice)
                if choice then M.static_analyzer_to_qf(choice) end
            end
        )
    end, { desc = "Run static analyzer to quickfix" })
end

return M

