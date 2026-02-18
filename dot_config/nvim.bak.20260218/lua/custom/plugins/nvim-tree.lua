return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true, -- This makes tree follow directory changes
      },
      git = {
        ignore = false,
      },
      actions = {
        open_file = {
          window_picker = {
            enable = true,
          },
        },
      },
      hijack_netrw = true,
      hijack_directories = {
        enable = false,
      },
      view = {
        width = {
          min = 30,
          max = 80,
          padding = 1,
        },
        adaptive_size = true,
        side = 'left',
      },
    }
    vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'File [E]xplorer', silent = true })
  end,
}
