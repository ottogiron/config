return {
  'L3MON4D3/LuaSnip',
  version = 'v2.*',
  build = 'make install_jsregexp',
  dependencies = {
    'rafamadriz/friendly-snippets',
  },
  config = function()
    local luasnip = require 'luasnip'

    luasnip.config.setup {}

    -- Load friendly-snippets
    require('luasnip.loaders.from_vscode').lazy_load()

    -- Keymaps for snippet navigation
    vim.keymap.set({ 'i', 's' }, '<C-k>', function()
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      end
    end, { silent = true, desc = 'Jump to next snippet placeholder' })

    vim.keymap.set({ 'i', 's' }, '<C-j>', function()
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      end
    end, { silent = true, desc = 'Jump to previous snippet placeholder' })

    vim.keymap.set({ 'i', 's' }, '<C-l>', function()
      if luasnip.choice_active() then
        luasnip.change_choice(1)
      end
    end, { silent = true, desc = 'Cycle snippet choice' })
  end,
}
