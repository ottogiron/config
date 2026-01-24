-- Shared LSP utilities for consistent keymaps and document highlighting
-- Used by lsp.lua, nvim-jdtls.lua, and nvim-metals.lua

local M = {}

-- Setup LSP keymaps for a buffer
-- Prefers Telescope if available, falls back to vim.lsp.buf
function M.setup_keymaps(bufnr)
  local map = function(keys, fn, desc)
    vim.keymap.set('n', keys, fn, { buffer = bufnr, desc = 'LSP: ' .. desc, silent = true })
  end

  local has_telescope, tb = pcall(require, 'telescope.builtin')
  local def = has_telescope and tb.lsp_definitions or vim.lsp.buf.definition
  local refs = has_telescope and tb.lsp_references or vim.lsp.buf.references
  local impl = has_telescope and tb.lsp_implementations or vim.lsp.buf.implementation
  local tdef = has_telescope and tb.lsp_type_definitions or vim.lsp.buf.type_definition
  local dsyms = has_telescope and tb.lsp_document_symbols or vim.lsp.buf.document_symbol
  local wsyms = has_telescope and tb.lsp_dynamic_workspace_symbols or vim.lsp.buf.workspace_symbol

  map('gd', def, '[G]oto [D]efinition')
  map('gr', refs, '[G]oto [R]eferences')
  map('gI', impl, '[G]oto [I]mplementation')
  map('<leader>D', tdef, 'Type [D]efinition')
  map('<leader>ds', dsyms, '[D]ocument [S]ymbols')
  map('<leader>ws', wsyms, '[W]orkspace [S]ymbols')
  map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  map('K', vim.lsp.buf.hover, 'Hover Documentation')
  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
end

-- Setup document highlight on cursor hold
function M.setup_document_highlight(client, bufnr)
  if client and client.server_capabilities.documentHighlightProvider then
    local hl_group = vim.api.nvim_create_augroup('lsp-highlight-' .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = hl_group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      group = hl_group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

-- Convenience function to setup both keymaps and highlighting
function M.on_attach(client, bufnr)
  M.setup_keymaps(bufnr)
  M.setup_document_highlight(client, bufnr)
end

return M
