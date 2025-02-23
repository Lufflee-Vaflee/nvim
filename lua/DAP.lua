print("Hello from DAP")
vim.env.DAP_executable = "empty"

function ClearCachedELF()
    print("Cleared cashed ELF: " .. vim.env.DAP_executable)
    vim.env.DAP_executable = "empty"
end

function LaunchELFExecutable()
    local executable = vim.env.DAP_executable
    local debug_info_cmd = "file " .. executable .. " | grep debug_info"

    if(os.execute(debug_info_cmd) == 512) then
        print("Founded cached debug executable: " .. executable)
        return executable
    end

    executable = vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    debug_info_cmd = "file " .. executable .. " | grep debug_info"
    if(os.execute(debug_info_cmd) == 512) then
        vim.env.DAP_executable = executable
        return executable
    end

    print("Didn't found executable file or file doesnt have debug symbols")
    vim.env.DAP_executable = "empty"
    return "empty"

end

function ConfigureDAP()
    local dap = require("dap")
    local path_to_dap = vim.fn.stdpath("data") .. "/mason/bin/codelldb"

    dap.adapters.codelldb = {
          type = "executable",
          command = path_to_dap,
    }

    dap.configurations.cpp = {
        {
            name = "Launch file",
            type = "codelldb",
            request = "launch",
            program = LaunchELFExecutable,
            cwd = vim.fn.getcwd(),
            stopOnEntry = false,
        },
    }

    local dapui = require("dapui")
    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.after.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.after.event_exited["dapui_config"] = function()
        dapui.close()
    end

    vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
    vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
    vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
    vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
    vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end)
    vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)

    vim.keymap.set('n', '<Leader>de', function()
        require('dap').close()
        require('dapui').close()
    end)

    vim.keymap.set('n', '<Leader>dc', function()
        ClearCachedELF()
        require('dap').clear_breakpoints()
    end)


end

ConfigureDAP()

