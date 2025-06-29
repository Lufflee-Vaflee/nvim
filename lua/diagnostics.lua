local config = {
    -- Basic options
    auto_close_qflist = false,       -- Auto-close quickfix when no errors

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
local function severityToType(severity)
    local types = { "E", "W", "I", "N" }
    return types[severity] or "E"
end

-- Convert severity name to severity level
local function SeveretyToLevel(name)
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
function LspToQf(severity_filter)
    local diagnostics = vim.diagnostic.get(nil)
    local min_severity = SeveretyToLevel(severity_filter)

    local qf_items = {}
    for _, diagnostic in ipairs(diagnostics) do
        if diagnostic.severity <= min_severity then
            table.insert(qf_items, {
                filename = vim.api.nvim_buf_get_name(diagnostic.bufnr),
                lnum = diagnostic.lnum + 1,  -- LSP uses 0-based, quickfix uses 1-based
                col = diagnostic.col + 1,    -- LSP uses 0-based, quickfix uses 1-based
                text = diagnostic.message,
                type = severityToType(diagnostic.severity)
            })
        end
    end

    vim.fn.setqflist(qf_items, 'r')
    HandleQF(#qf_items)

    return #qf_items
end

-- Helper function to open/close quickfix window based on config
function HandleQF(count)
    if count > 0 then
        vim.api.nvim_command("copen")
    elseif config.auto_close_qflist then
        vim.api.nvim_command("cclose")
    end
end

-- Function to toggle the quickfix window
function ToggleQF()
    local qf_win = vim.fn.getqflist({winid = 0}).winid
    if qf_win == 0 then
        vim.api.nvim_command("copen")
        vim.api.nvim_command("wincmd J") -- Move to bottom
    else
        vim.api.nvim_command("cclose")
    end
end

local cmd = nil

function BuildToQF()
    if cmd == nil then
        cmd = vim.fn.input('make', " --no-print-directory" .. " --silent" ..' -C '  .. vim.fn.getcwd() .. " all")
    else
        cmd = vim.fn.input('make', cmd)
    end

    vim.api.nvim_command("make! " .. cmd)

    local qf_list = vim.fn.getqflist()
    HandleQF(#qf_list)

    return #qf_list
end

local vtext = false

function ToggleVText()
    vim.diagnostic.config({
      virtual_text = vtext,
    })

    vtext = not vtext
end

vim.keymap.set("n", "<leader>qf", ToggleQF, { desc = "Toggle quickfix window" })
vim.keymap.set("n", "<leader>qdd", function() LspToQf("HINT") end, { desc = "LSP diagnostics to quickfix" })
vim.keymap.set("n", "<leader>qdi", function() LspToQf("INFO") end, { desc = "LSP diagnostics to quickfix" })
vim.keymap.set("n", "<leader>qdw", function() LspToQf("WARN") end, { desc = "LSP diagnostics to quickfix" })
vim.keymap.set("n", "<leader>qde", function() LspToQf("ERROR") end, { desc = "LSP diagnostics to quickfix" })

vim.keymap.set("n", "<leader>qdv", ToggleVText, { desc = "Toggle virtual text" })
vim.keymap.set("n", "<leader>qb", BuildToQF, { desc = "Build with cached cmd and capture in quickfix" })

