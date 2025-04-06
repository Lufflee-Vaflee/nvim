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


