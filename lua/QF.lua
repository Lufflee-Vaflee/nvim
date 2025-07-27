
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.cmd("wincmd J")
        vim.wo.wrap = true
    end,
})

local qf_original_list = {}
local qf_is_filtered = false

local function deep_copy(t)
    if type(t) ~= 'table' then return t end
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = deep_copy(v)
    end
    return copy
end

local function toggle_qf_filter()
    local qflist = vim.fn.getqflist()
    if #qflist == 0 then return end

    if not qf_is_filtered then
        qf_original_list = deep_copy(qflist)
        local filtered = {}
        for _, item in ipairs(qflist) do
            if item.bufnr ~= 0 then
                table.insert(filtered, item)
            end
        end
        vim.fn.setqflist(filtered, 'r')
        qf_is_filtered = true
    else
        vim.fn.setqflist(qf_original_list, 'r')
        qf_is_filtered = false
    end
end

local function open_qf_full()
    vim.cmd(":copen")
    local height = vim.opt.lines:get() - 20
    vim.cmd("resize " .. height)
end

local function open_qf_standart()
    vim.cmd(":copen")
    vim.cmd("resize 10")
end

vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

vim.keymap.set("n", "<leader>qg", open_qf_full)
vim.keymap.set("n", "<leader>qn", open_qf_standart)
vim.keymap.set("n", "<leader>qe", "<cmd>cclose<CR>")
vim.keymap.set("n", "<leader>qf", toggle_qf_filter)

vim.api.nvim_set_hl(0, "QfFileName", {fg = '#3794ff'} )
vim.api.nvim_set_hl(0, "QfLineNr", {fg = '#9cdcfe'} )


