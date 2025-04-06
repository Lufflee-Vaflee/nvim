vim.api.nvim_set_hl(0, "DiffTextChanged", { fg =0x1F58AE,  link = "DiffLineChanged" } )

vim.opt.fillchars:append { eob = " ", diff = "╱"}

-- Make diff symbols less bright
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        -- Soften the diff delete (DiffDelete) color
        vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#5a5a5a", link="DiffLineDelete" })
    end,
})

-- gitgraph.nvim configuration
local gitgraph = require('gitgraph')
gitgraph.setup({
    symbols = {
        merge_commit = '◎',
        commit = '◯',
        merge_commit_end = '◉',
        commit_end = '◉',
        -- Advanced symbols for the graph visualization
        GVER = '│',
        GHOR = '─',
        GCLD = '╮',
        GCRD = '╭',
        GCLU = '╯',
        GCRU = '╰',
    },
    format = {
        timestamp = '%Y-%m-%d %H:%M:%S',
        fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
    },
    hooks = {
        -- Hook to handle commit selection
        on_select_commit = function(commit)
            if pcall(require, "diffview") then
                vim.cmd(':DiffviewOpen ' .. commit.hash .. '^!')
            else
                print('Selected commit: ' .. commit.hash)
            end
        end,
        -- Hook to handle range commit selection
        on_select_range_commit = function(from, to)
            if pcall(require, "diffview") then
                vim.cmd(':DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
            else
                print('Selected range: ' .. from.hash .. ' to ' .. to.hash)
            end
        end,
    }
})

local inspect_output = vim.api.nvim_exec2("Inspect", {output = true}).output

print(inspect_output)

function attach_to_buffer(buffer_id)
    buffer_id = buffer_id or 0  -- Default to current buffer if none specified

    -- Create an autocommand group for our cursor events
    local cursor_group = vim.api.nvim_create_augroup("CursorMovementGroup_" .. buffer_id, { clear = true })

    -- Normal mode cursor movement
    vim.api.nvim_create_autocmd("CursorMoved", {
        group = cursor_group,
        buffer = buffer_id,
        callback = function()
            local cursor = vim.api.nvim_win_get_cursor(0)
            print("Normal mode - Line: " .. cursor[1] .. ", Column: " .. cursor[2])

            -- Your custom logic here when cursor moves in normal mode
        end,
    })

    print("Cursor movement detection attached to buffer " .. buffer_id)

    local inspect_output = vim.api.nvim_exec2("Inspect", {output = true}).output

    
end

local on_gitgraph_open = function()
    vim.cmd.NvimTreeClose()
    gitgraph.draw({}, { all = true, max_count = 5000 })
    attach_to_buffer(0)
end

-- Keymappings for gitgraph.nvim
vim.keymap.set('n', '<leader>gg', on_gitgraph_open, { noremap = true, silent = true })

