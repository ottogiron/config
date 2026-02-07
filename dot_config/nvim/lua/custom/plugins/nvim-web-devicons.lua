return {
  'nvim-tree/nvim-web-devicons',
  opts = {
    color_icons = true,
    default = true, -- use default icons when no icon found
    override_by_extension = {
      ['aster'] = {
        icon = '★',
        color = '#FFD700',
        name = 'Aster',
      },
    },
  },
}
