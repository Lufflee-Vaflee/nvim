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
                vim.cmd(":tabprevious")
                vim.cmd(":tabclose")
            else
                print('Selected commit: ' .. commit.hash)
            end
        end,
        -- Hook to handle range commit selection
        on_select_range_commit = function(from, to)
            if pcall(require, "diffview") then
                vim.cmd(':DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
                vim.cmd(":tabprevious")
                vim.cmd(":tabclose")
            else
                print('Selected range: ' .. from.hash .. ' to ' .. to.hash)
            end
        end,
    }
})

local on_gitgraph_open = function()
    vim.cmd.NvimTreeClose()
    vim.cmd(":tabnew")
    gitgraph.draw({}, { all = true, max_count = 5000 })
    vim.cmd(":tabprevious")
    vim.cmd(":tabclose")
end

-- Keymappings for gitgraph.nvim
vim.keymap.set('n', '<leader>gg', on_gitgraph_open, { noremap = true, silent = true })

require('gitsigns').setup {
    signs_staged_enable = true,
    current_line_blame = true
}

