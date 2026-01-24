return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  config = function()
    local wk = require 'which-key'
    wk.setup()

    -- Register keymap groups for better discoverability
    wk.add {
      { '<leader>c', group = 'Code' },
      { '<leader>d', group = 'Document/Debug' },
      { '<leader>g', group = 'Git' },
      { '<leader>r', group = 'Rename/Reload' },
      { '<leader>s', group = 'Search' },
      { '<leader>w', group = 'Workspace' },
      { 'g', group = 'Goto' },
    }
  end,
}
