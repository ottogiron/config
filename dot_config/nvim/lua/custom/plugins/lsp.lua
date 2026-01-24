return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', version = '*' },
    -- optional but referenced below:
    -- 'nvim-telescope/telescope.nvim',
  },
  config = function()
    -- LSP servers (single source of truth)
    local servers = {
      clangd = {},
      rust_analyzer = {},
      kotlin_lsp = {},
      zls = {},
      gradle_ls = {},
      gdscript = {},
      -- jdtls is configured in ftplugin/java.lua via nvim-jdtls
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = {
                '${3rd}/luv/library',
                unpack(vim.api.nvim_get_runtime_file('', true)),
              },
            },
            completion = { callSnippet = 'Replace' },
          },
        },
      },
    }

    -- Diagnostics (tweak to taste)
    vim.diagnostic.config {
      virtual_text = true,
      underline = true,
      signs = true,
      update_in_insert = false,
      severity_sort = true,
    }

    -- Mason core
    require('mason').setup()

    -- Ensure tools based on servers list (+ extra formatters/linters)
    -- Godot LSP is built-in to the editor, not a Mason package.
    local ensure = vim.tbl_filter(function(server)
      return server ~= 'gdscript'
    end, vim.tbl_keys(servers))

    vim.list_extend(ensure, {
      'jdtls', -- installed by Mason, configured in ftplugin/java.lua
      'stylua',
      'clang-format',
      'google-java-format',
      'vscode-spring-boot-tools',
      'prettier',
      'gdtoolkit',
    })

    require('mason-tool-installer').setup {
      ensure_installed = ensure,
      auto_update = false,
      run_on_start = true,
    }

    -- On-attach: keymaps + highlights (using shared module)
    local lsp_utils = require 'custom.lsp-utils'
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach-clean', { clear = true }),
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        lsp_utils.on_attach(client, event.buf)
      end,
    })

    -- Create base capabilities from nvim-cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Add snippet support
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = { 'documentation', 'detail', 'additionalTextEdits' },
    }

    -- Mason LSP bridge
    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }

    -- Manually setup servers not managed by Mason (like sourcekit)
    vim.lsp.config('sourcekit', {
      capabilities = {
        workspace = {
          didChangeWatchedFiles = { dynamicRegistration = true },
        },
      },
    })

    vim.lsp.enable 'sourcekit'
    -- Fidget UI (quiet for jdtls)
    require('fidget').setup {
      progress = {
        ignore = { 'jdtls' },
        suppress_on_insert = true,
        ignore_empty_message = true,
        display = {
          progress_ttl = 1,
          render_limit = 6,
          skip_history = true,
        },
      },
      notification = {
        poll_rate = 50,
        filter = vim.log.levels.WARN, -- show only warnings/errors
        window = {
          winblend = 100,
          border = 'none',
        },
      },
    }
  end,
}
