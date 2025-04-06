-- Configuration options with default values
local config = {
    -- Basic options
    auto_open_qflist = true,         -- Auto-open quickfix after collecting diagnostics
    auto_close_qflist = false,       -- Auto-close quickfix when no errors
    focus_qflist = true,             -- Focus quickfix window after opening

    -- Build command options
    build_command = "all",          -- Default build command
    build_dir = "build",                  -- Default build directory (empty = cwd)

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

-- Convert LSP diagnostics severity to quickfix type
local function severity_to_type(severity)
    local types = { "E", "W", "I", "N" }
    return types[severity] or "E"
end

-- Convert severity name to severity level
local function severity_name_to_level(name)
    if name == "ERROR" then
        return 1
    end
    if name == "WARN" then
        return 2
    end
    if name == "INFO" then
        return 3
    end
    if name == "HINT" then
        return 4
    end

    return 4
end

-- Function to collect LSP diagnostics and put them in quickfix
function lsp_diagnostics_to_qf(severity_filter)
    local diagnostics = vim.diagnostic.get(nil)
    local min_severity = severity_name_to_level(severity_filter)

    local qf_items = {}
    for _, diagnostic in ipairs(diagnostics) do
        if diagnostic.severity <= min_severity then
            table.insert(qf_items, {
                filename = vim.api.nvim_buf_get_name(diagnostic.bufnr),
                lnum = diagnostic.lnum + 1,  -- LSP uses 0-based, quickfix uses 1-based
                col = diagnostic.col + 1,    -- LSP uses 0-based, quickfix uses 1-based
                text = diagnostic.message,
                type = severity_to_type(diagnostic.severity)
            })
        end
    end

    vim.fn.setqflist(qf_items, 'r')
    handle_qf_window(#qf_items)

    return #qf_items
end

-- Helper function to open/close quickfix window based on config
function handle_qf_window(count)
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
function toggle_quickfix()
    local qf_win = vim.fn.getqflist({winid = 0}).winid
    if qf_win == 0 then
        vim.api.nvim_command("copen")
        vim.api.nvim_command("wincmd J") -- Move to bottom
    else
        vim.api.nvim_command("cclose")
    end
end

vim.keymap.set("n", "<leader>qf", toggle_quickfix, { desc = "Toggle quickfix window" })
vim.keymap.set("n", "<leader>qdh", function() lsp_diagnostics_to_qf("HINT") end, { desc = "LSP diagnostics to quickfix" })
vim.keymap.set("n", "<leader>qdi", function() lsp_diagnostics_to_qf("INFO") end, { desc = "LSP diagnostics to quickfix" })
vim.keymap.set("n", "<leader>qdw", function() lsp_diagnostics_to_qf("WARN") end, { desc = "LSP diagnostics to quickfix" })
vim.keymap.set("n", "<leader>qde", function() lsp_diagnostics_to_qf("ERROR") end, { desc = "LSP diagnostics to quickfix" })

-- Function to run build command and capture output in quickfix
function build_to_qf()
    local cmd = config.build_command
    local dir = config.build_dir

    -- Change to build directory if specified
    local current_dir = vim.fn.getcwd()
    if dir ~= "" then
        vim.api.nvim_command("lcd " .. current_dir .. "/" .. dir)
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

vim.keymap.set("n", "<leader>qb", build_to_qf, { desc = "Build and capture in quickfix" })
