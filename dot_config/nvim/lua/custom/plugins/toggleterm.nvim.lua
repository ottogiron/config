return {
  'akinsho/toggleterm.nvim',
  version = '*',
  keys = {
    { '<leader>t', '<cmd>ToggleTerm<cr>', desc = '[T]erminal' },
    { '<C-\\>', '<cmd>ToggleTerm direction=vertical<cr>', desc = 'Vertical terminal' },
  },
  opts = {},
}
