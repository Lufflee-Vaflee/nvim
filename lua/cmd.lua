vim.g.asyncrun_open = 10

local cachedCmds = {}
local cmd = nil --prepare to catch entered command

-- function to capture cmd input right after pressing enter
vim.api.nvim_create_autocmd("CmdlineLeave", {
    pattern = ":",
    callback = function()
        -- Get the command that was just executed
        local last_cmd = vim.fn.getcmdline()
        print(last_cmd)
        if cmd ~= nil then
            cachedCmds[cmd] = last_cmd
        end
        cmd = nil
    end
})

local defaultCmdPrefix = "<leader>sc"
local defaultAsyncCmdPrefix = "<leader>c"

--my little lovely callack hell
--restore previous cmd if it was cached
local function cacheFunc(name)
    local cached = cachedCmds[name]
    if cached ~= nil then
        vim.api.nvim_feedkeys(":" .. cached, "n", true)
        return true
    end

    return false
end


local function createCmd(name, compiler, default_args, key)
    cachedCmds[name] = nil

    local acmdFunc = function()
        if not cacheFunc(name .. "a") then
            vim.api.nvim_feedkeys(":AsyncRun " .. compiler .. " " .. default_args, "n", true)
        end

        cmd = name .. "a" --preparing to catch cmd to cache it
    end

    local cmdFunc = function()
        if not cacheFunc(name) then
            vim.api.nvim_feedkeys(":" .. compiler .. " " .. default_args, "n", true)
        end

        cmd = name --preparing to catch cmd to cache it
    end

    vim.keymap.set("n", defaultAsyncCmdPrefix .. key, acmdFunc, {
        desc = "Cached Async cmd for " .. name
    })

    vim.keymap.set("n", defaultCmdPrefix .. key, cmdFunc, {
        desc = "Cached cmd for " .. name
    })
end


local search_catalogs = {}
search_catalogs[0] = vim.fn.getcwd()
search_catalogs[1] = "~/.config/nvim"
local ignore_catalogs = {}
ignore_catalogs[0] = "build"
ignore_catalogs[1] = ".git"

local function concatenate_catalogs(catalogs, separator)
    local result = ""
    for i = 0, #catalogs, 1 do
        result = result .. catalogs[i] .. separator
    end

    return result
end

vim.o.grepprg = 'grep'
vim.o.grepformat = '%f:%l:%m'

createCmd("make", "make", "--no-print-directory" .. " --silent" ..' -C '  .. vim.fn.getcwd() .. " all", "m")
createCmd("grep", "grep", "--exclude-dir={" .. concatenate_catalogs(ignore_catalogs, ',') .."}" .. " --ignore-case ".. "-rni" .. " {text} " .. concatenate_catalogs(search_catalogs, " "), "g")

--createCmd("find", "grep", " | find_for_grep.sh " .. concatenate_catalogs(search_catalogs, " ") .. " -type f -name '{pattern}'", "f")

vim.keymap.set("n", defaultAsyncCmdPrefix .. "a", "<cmd>AsyncStop<CR>", { desc = "Stop async command" })

