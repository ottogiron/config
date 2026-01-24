-- Full nvim-jdtls configuration for Java files
-- This file runs every time a Java file is opened

local jdtls = require 'jdtls'
local lsp_utils = require 'custom.lsp-utils'

-- Find project root
local root_dir = vim.fs.root(0, { 'gradlew', 'mvnw', 'pom.xml', 'build.gradle', '.git' })

-- Don't start if no project root found
if not root_dir then
  vim.notify('jdtls: No project root found', vim.log.levels.WARN)
  return
end

-- Workspace directory (per-project data, persists across reboots)
local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = vim.fn.stdpath 'data' .. '/jdtls-workspace/' .. project_name

-- Spring Boot bundles (only if jar files exist)
local bundles = {}
local ok, spring_boot = pcall(require, 'spring_boot')
if ok and spring_boot.java_extensions then
  local extensions = spring_boot.java_extensions()
  if extensions and #extensions > 0 then
    for _, jar in ipairs(extensions) do
      -- Only add if file exists
      if vim.fn.filereadable(jar) == 1 then
        table.insert(bundles, jar)
      end
    end
  end
end

-- Capabilities from nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if has_cmp then
  capabilities = vim.tbl_deep_extend('force', capabilities, cmp_lsp.default_capabilities())
end

-- Add snippet support
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { 'documentation', 'detail', 'additionalTextEdits' },
}

local config = {
  cmd = { vim.fn.stdpath 'data' .. '/mason/bin/jdtls', '-data', workspace_dir },
  root_dir = root_dir,
  capabilities = capabilities,
  init_options = {
    bundles = bundles,
  },
  settings = {
    java = {
      -- Let jdtls manage compilation
      autobuild = { enabled = true },
    },
  },
  on_attach = function(client, bufnr)
    lsp_utils.on_attach(client, bufnr)

    -- Java-specific keymaps
    local map = function(keys, fn, desc)
      vim.keymap.set('n', keys, fn, { buffer = bufnr, desc = 'Java: ' .. desc })
    end
    local vmap = function(keys, fn, desc)
      vim.keymap.set('v', keys, fn, { buffer = bufnr, desc = 'Java: ' .. desc })
    end

    map('<leader>co', jdtls.organize_imports, '[O]rganize imports')
    map('<leader>cv', jdtls.extract_variable, 'Extract [v]ariable')
    vmap('<leader>cv', function()
      jdtls.extract_variable(true)
    end, 'Extract [v]ariable')
    map('<leader>cc', jdtls.extract_constant, 'Extract [c]onstant')
    vmap('<leader>cc', function()
      jdtls.extract_constant(true)
    end, 'Extract [c]onstant')
    vmap('<leader>cm', function()
      jdtls.extract_method(true)
    end, 'Extract [m]ethod')
  end,
}

jdtls.start_or_attach(config)
