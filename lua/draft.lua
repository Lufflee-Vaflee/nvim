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

-- Function to run static analyzer and capture output in quickfix
--function static_analyzer_to_qf(analyzer_name, custom_args)
--    local analyzer = config.static_analyzers[analyzer_name]
--    if not analyzer then
--        print("Unknown analyzer: " .. analyzer_name)
--        return 0
--    end
--
--    local args = custom_args or analyzer.args
--    local cmd = analyzer.command .. " " .. args
--
--    -- Set errorformat for this analyzer
--    vim.api.nvim_command("set errorformat=" .. analyzer.errorformat)
--
--    -- Run the command and capture output
--    vim.api.nvim_command("cexpr system('" .. cmd .. "')")
--
--    -- Restore default errorformat if needed
--    vim.api.nvim_command("set errorformat&")
--
--    -- Get error count and handle quickfix window
--    local qf_list = vim.fn.getqflist()
--    handle_qf_window(#qf_list)
--
--    return #qf_list
--end

--vim.keymap.set("n", "<leader>qa", function()
--    vim.ui.select(
--        vim.tbl_keys(config.static_analyzers),
--        { prompt = "Select static analyzer:" },
--        function(choice)
--            if choice then static_analyzer_to_qf(choice) end
--        end
--    )
--end, { desc = "Run static analyzer to quickfix" })

