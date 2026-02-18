return {
  'folke/zen-mode.nvim',
  cmd = 'ZenMode',
  keys = { { '<leader>z', '<cmd>ZenMode<CR>', desc = 'Toggle ZenMode' } },
  config = function()
    require('zen-mode').setup {
      window = {
        width = 100,
        options = { number = true, relativenumber = false },
      },
      plugins = {
        options = { enabled = true, ruler = false, showcmd = false },
        gitsigns = { enabled = true },
      },
    }
  end,
}
