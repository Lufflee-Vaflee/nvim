-- External formatter integration for Neovim
-- Provides buffer-specific formatting without plugins

local M = {}

-- Map filetypes to formatter commands
-- Format: filetype = { cmd = command, args = {arguments} }
M.formatters = {
  go = { cmd = "gofmt", args = {} },
  c = { cmd = "clang-format", args = {} },
  cpp = { cmd = "clang-format", args = {} },
  js = { cmd = "clang-format", args = {} },
  ts = { cmd = "clang-format", args = {} },
  lua = { cmd = "stylua", args = {"-"} },
}

-- Check if a command is executable
local function is_executable(cmd)
  return vim.fn.executable(cmd) == 1
end

-- Format the current buffer using the appropriate external formatter
function M.format_buffer()
  local filetype = vim.bo.filetype
  local formatter = M.formatters[filetype]

  if not formatter then
    vim.notify("No formatter configured for filetype: " .. filetype, vim.log.levels.WARN)
    return
  end

  if not is_executable(formatter.cmd) then
    vim.notify("Formatter " .. formatter.cmd .. " not found. Please install it.", vim.log.levels.ERROR)
    return
  end

  -- Save cursor position
  local cursor_pos = vim.fn.getcurpos()

  -- Get buffer content
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local content = table.concat(lines, "\n")

  -- Prepare command
  local cmd = formatter.cmd
  local args = formatter.args

  -- Create temporary files for stdin/stdout
  local tmp_input = vim.fn.tempname()
  local tmp_output = vim.fn.tempname()

  -- Write buffer content to temp file
  vim.fn.writefile(vim.split(content, "\n"), tmp_input)

  -- Build the shell command
  local full_cmd = cmd .. " " .. table.concat(args, " ") .. " < " .. tmp_input .. " > " .. tmp_output .. " 2>&1"

  -- Execute formatter
  local exit_code = vim.fn.system(full_cmd)
  local success = vim.v.shell_error == 0

  if success then
    -- Read formatted content
    local formatted_content = vim.fn.readfile(tmp_output)

    -- Update buffer with formatted content
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted_content)

    -- Restore cursor position
    vim.fn.setpos('.', cursor_pos)

    vim.notify("Buffer formatted", vim.log.levels.INFO)
  else
    -- Read error message
    local error_msg = vim.fn.readfile(tmp_output)
    vim.notify("Formatting failed: " .. table.concat(error_msg, "\n"), vim.log.levels.ERROR)
  end

  -- Clean up temporary files
  vim.fn.delete(tmp_input)
  vim.fn.delete(tmp_output)
end

-- Set up key mappings
function M.setup()
  -- Format buffer with <leader>f
  vim.api.nvim_set_keymap('n', '<leader>f', ':lua require("format").format_buffer()<CR>',
    { noremap = true, silent = true, desc = "Format current buffer" })

  -- Create a command for formatting
  vim.api.nvim_create_user_command('Format', function()
    M.format_buffer()
  end, { desc = 'Format current buffer with external formatter' })
end

return M

