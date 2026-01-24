return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',
    'nvim-telescope/telescope.nvim',
  },
  cmd = 'Neogit',
  keys = {
    { '<leader>gg', '<cmd>Neogit<CR>', desc = '[G]it status (Neo[g]it)' },
    { '<leader>gc', '<cmd>Neogit commit<CR>', desc = '[G]it [c]ommit' },
    { '<leader>gp', '<cmd>Neogit push<CR>', desc = '[G]it [p]ush' },
    { '<leader>gl', '<cmd>Neogit pull<CR>', desc = '[G]it pul[l]' },
  },
  opts = {
    integrations = {
      diffview = true,
      telescope = true,
    },
  },
}
