return {
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      local fallback_bin = '/Users/ottogiron/workspace/github.com/ottogiron/aster/target/release/aster_lsp'
      local path_bin = vim.fn.exepath('aster_lsp')
      local resolved_bin = path_bin ~= '' and path_bin or (vim.fn.executable(fallback_bin) == 1 and fallback_bin or nil)

      opts.servers.aster_lsp = {
        mason = false,
        cmd = resolved_bin and { resolved_bin } or nil,
        filetypes = { 'aster' },
        root_markers = { '.git', 'Cargo.toml' },
        single_file_support = true,
      }

      opts.setup = opts.setup or {}
      opts.setup.aster_lsp = function(_, server_opts)
        local cmd = server_opts.cmd and server_opts.cmd[1] or nil
        if not cmd or vim.fn.executable(cmd) ~= 1 then
          vim.schedule(function()
            vim.notify('aster_lsp not found in PATH or fallback path. Build/install aster_lsp to enable Aster LSP.', vim.log.levels.WARN)
          end)
          return true
        end
      end
    end,
  },
}
