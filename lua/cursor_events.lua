print("Hello from cursor events")

-- Module for buffer-specific cursor movement detection

-- Function to attach cursor movement detection to a specific buffer
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

    -- Insert mode cursor movement
    vim.api.nvim_create_autocmd("CursorMovedI", {
        group = cursor_group,
        buffer = buffer_id,
        callback = function()
            local cursor = vim.api.nvim_win_get_cursor(0)
            print("Insert mode - Line: " .. cursor[1] .. ", Column: " .. cursor[2])

            -- Your custom logic here when cursor moves in insert mode
        end,
    })

    print("Cursor movement detection attached to buffer " .. buffer_id)
end

-- Function to detach cursor movement detection from a specific buffer
function detach_from_buffer(buffer_id)
    buffer_id = buffer_id or 0  -- Default to current buffer if none specified

    local group_name = "CursorMovementGroup_" .. buffer_id
    pcall(vim.api.nvim_del_augroup_by_name, group_name)

    print("Cursor movement detection detached from buffer " .. buffer_id)
end


