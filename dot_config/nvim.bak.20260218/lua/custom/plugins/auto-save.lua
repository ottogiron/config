return {
  'pocco81/auto-save.nvim',
  version = '*', -- Use the latest stable version
  event = { 'BufReadPost' }, -- Only load on InsertLeave (removed TextChanged)
  config = function()
    require('auto-save').setup {
      enabled = false,

      -- Only save on focus change or when leaving the buffer
      trigger_events = { 'FocusLost', 'BufLeave' },

      execution_message = {
        message = function() -- message to print on save
          return ('AutoSave: saved at ' .. vim.fn.strftime '%H:%M:%S')
        end,
        dim = 0.18, -- dim the color of `message`
        cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea
      },

      condition = function(buf)
        -- Only save if the buffer has been modified.
        if not vim.bo[buf].modified then
          return false
        end

        -- Disable auto-save in insert mode
        if vim.fn.mode() == 'i' then
          return false
        end

        local ft = vim.bo[buf].filetype
        local excluded_filetypes = {
          'TelescopePrompt', -- Telescope search
          'gitcommit', -- Git commit messages
          'gitrebase', -- Git rebase files
          'help', -- Help files
          'log', -- Log files
        }
        for _, excluded_ft in ipairs(excluded_filetypes) do
          if ft == excluded_ft then
            return false
          end
        end

        return true
      end,

      write_all_buffers = false, -- Only write the current buffer

      debounce_delay = 2000, -- Increase delay to 2000ms to reduce frequency

      callbacks = {
        before_saving = function()
          -- Add any commands to run before saving (optional)
        end,
        after_saving = function()
          -- Add any commands to run after saving (optional)
        end,
      },
    }
  end,
}
