return {
  'stevearc/conform.nvim',
  dependencies = { 'williamboman/mason.nvim' },
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      lua = { 'stylua' },
      rust = { 'rustfmt' },
      cpp = { 'clang-format' },
      javascript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      java = { 'google-java-format' },
      gdscript = { 'gdformat' },
      gdshader = { 'gdformat' },
    },
    formatters = {
      ['google-java-format'] = {
        prepend_args = { '--aosp' }, -- Use AOSP style (4 spaces instead of 2)
      },
    },
  },
  config = function(_, opts)
    require('conform').setup(opts)

    -- Java-specific indentation to match google-java-format (4 spaces)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'java' },
      callback = function()
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
      end,
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'gdscript', 'gdshader' },
      callback = function()
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
      end,
    })

    vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
      require('conform').format { async = true, lsp_fallback = true }
    end, { desc = 'Format file' })
  end,
}
