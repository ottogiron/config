# AGENTS.md

Guidelines for agentic coding assistants working in this Neovim configuration repo.

## Overview

- Modular config based on kickstart.nvim
- Plugin manager: lazy.nvim
- Plugin specs live in `lua/custom/plugins/`
- Core settings and plugin loader live in `init.lua`

## Build/Lint/Test Commands

```bash
make fmt                            # Format all Lua files
make fmt-check                      # Check formatting (CI)
stylua .                            # Format all Lua files
stylua --check .                    # Check formatting (CI)
```

No build step and no automated test runner.
Single-test equivalent: not applicable. Use targeted validation in Neovim.

### Validation (run in Neovim)

```vim
:checkhealth kickstart
:checkhealth mason
:lua print(package.loaded['custom.functions'] ~= nil and 'Loaded' or 'Not loaded')
:Lazy reload
```

### Targeted checks (per file/module)

```vim
:luafile %
:lua require('custom.functions')
```

## Repository Layout

```
init.lua
lua/custom/functions.lua
lua/custom/plugins/
lua/kickstart/plugins/
```

## Code Style Guidelines

### Formatting (.stylua.toml)

- Indentation: 2 spaces (no tabs); Java/Godot use 4 spaces via ftplugin/autocmds
- Line width: 160 chars max
- Quotes: Prefer single quotes
- Call parentheses: Omit for single string arg
- Line endings: Unix (LF)

### Import Patterns

```lua
local cmp = require 'cmp'                 -- single string arg, no parens
require('lazy').setup('custom.plugins', {}) -- parens for clarity
```

### Naming Conventions

| Element        | Convention   | Examples                              |
|----------------|--------------|----------------------------------------|
| Variables      | snake_case   | `root_markers`, `hl_group`            |
| Functions      | camelCase    | `isMacOS`, `startThemeWatcher`        |
| Plugin tables  | snake_case   | `servers`, `ensure`, `formatters_by_ft`|
| Augroup names  | kebab-case   | `'lsp-attach-clean'`, `'highlight-yank'`|
| Module exports | Pascal case  | `local M = {}` then `return M`        |

### Error Handling

Use `pcall` for safe requires and external calls:

```lua
local ok, tb = pcall(require, 'telescope.builtin')
local def = ok and tb.lsp_definitions or vim.lsp.buf.definition

local loaded, _ = pcall(require, 'custom.functions')
if not loaded then vim.notify('Failed to load', vim.log.levels.WARN) end
```

### Comments

```lua
-- Single line
-- NOTE: Important info
-- TODO: Future work
--[[ Section header ]]
--[[ Multi-line block comment ]]
```

### Type Annotations

```lua
---@diagnostic disable-next-line: undefined-field
---@type render.md.UserConfig
```

## Plugin Configuration Patterns

### Basic Plugin Spec

```lua
return { 'author/plugin-name', config = function() require('plugin-name').setup() end }
```

### With Dependencies and Options

```lua
return {
  'stevearc/conform.nvim',
  dependencies = { 'williamboman/mason.nvim' },
  opts = { formatters_by_ft = { lua = { 'stylua' } } },
  config = function(_, opts) require('conform').setup(opts) end,
}
```

### Lazy Loading

```lua
event = 'VeryLazy'                -- by event
ft = { 'java' }                   -- by filetype
cmd = { 'TmuxNavigateLeft' }      -- by command
keys = { { '<leader>z', '<cmd>ZenMode<CR>', desc = 'Toggle ZenMode' } }
```

### Conditional Dependencies

```lua
dependencies = {
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = function() return vim.fn.executable 'make' == 1 end },
}
```

### Version Pinning

```lua
version = '*'          -- latest stable
version = false        -- no lock
version = 'v2.*'       -- major version pin
```

### Keymaps

```lua
vim.keymap.set('n', '<leader>f', function()
  require('conform').format { async = true, lsp_fallback = true }
end, { desc = '[F]ormat file' })
```

### Autocmds

```lua
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('group-name', { clear = true }),
  pattern = { 'gdscript', 'gdshader' },
  callback = function() vim.opt_local.shiftwidth = 4 end,
})
```

### Module Export Pattern

```lua
local M = {}
function M.setup_keymaps(bufnr) --[[ code ]] end
function M.setup_highlight(client, bufnr) --[[ code ]] end
function M.on_attach(client, bufnr) --[[ combines both ]] end
return M
```

## LSP and Formatting

- LSP servers are defined in `lua/custom/plugins/lsp.lua` (single source of truth).
- Mason installs LSP servers from the `servers` table, except ones that are not Mason packages (e.g., `gdscript`).
- Formatters are configured in `lua/custom/plugins/formatting.lua` via conform.nvim.
- `<leader>f` formats the current buffer or selection.

## Important Settings

- `jj` -> `<Esc>` in insert mode
- Swap files disabled
- Auto-comment continuation disabled
- `vim.o.exrc = true` enables per-project `.nvim.lua`

## Cursor/Copilot Rules

No `.cursor/rules`, `.cursorrules`, or `.github/copilot-instructions.md` files were found.
