# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a modular Neovim configuration based on kickstart.nvim, heavily customized with additional plugins and features. The configuration uses lazy.nvim as the plugin manager and is organized with a clear separation between core settings and plugin-specific configurations.

## Architecture

### Configuration Structure

```
~/.config/nvim/
├── init.lua                      # Core settings, keymaps, autocommands, plugin loader
└── lua/
    ├── custom/
    │   ├── functions.lua         # Custom utility functions (theme watcher, etc.)
    │   └── plugins/              # Modular plugin configurations (auto-loaded by lazy.nvim)
    │       ├── lsp.lua           # LSP configuration with Mason integration
    │       ├── formatting.lua    # Code formatting with conform.nvim
    │       ├── nvim-cmp.lua      # Completion configuration
    │       ├── telescope.lua     # Fuzzy finder setup
    │       ├── theme-watcher.lua # macOS theme synchronization
    │       └── *.lua             # Additional plugin configs
    └── kickstart/
        └── plugins/              # Original kickstart plugin configs (debug, etc.)
```

### Plugin Loading Pattern

Plugins are auto-loaded from `lua/custom/plugins/` directory. Each file returns a lazy.nvim spec table:

```lua
return {
  'plugin/name',
  dependencies = { ... },
  config = function() ... end,
}
```

## Key Architectural Decisions

### LSP Configuration (lua/custom/plugins/lsp.lua)

- **Single Source of Truth**: All LSP servers are defined in the `servers` table at the top of the file
- **Mason Integration**: Automatically installs LSP servers, formatters, and linters from the `servers` list
- **Manual Server Setup**: SourceKit LSP is manually configured outside Mason for Swift/Objective-C support
- **Capabilities Merge**: Server capabilities are merged with defaults before setup

### Theme Management

- **System Theme Sync**: Custom `theme-watcher.lua` plugin uses `lua/custom/functions.lua` to sync with macOS system theme
- **Transparent Background**: Set in `init.lua` with highlight overrides for Normal, SignColumn, etc.
- **Primary Theme**: Uses Catppuccin with fallback to Tokyo Night

### Per-Project Configuration

- `vim.o.exrc = true` enables loading of `.nvim.lua` or `.exrc` files in project directories
- Used for project-specific LSP settings or keybindings

## Development Workflow

### Testing Configuration Changes

**Reload entire configuration:**
```
:source %
```
Or use the keybinding: `<leader>rl` (defined in init.lua:46)

**Reload Lua module:**
```lua
:lua package.loaded['module.name'] = nil
:lua require('module.name')
```

### Plugin Management

**View plugin status:**
```
:Lazy
```

**Update plugins:**
```
:Lazy update
```

**LSP/tool management:**
```
:Mason
```

**Check health:**
```
:checkhealth
```

### Debugging Issues

1. Check LSP status: `:LspInfo`
2. View logs: `:Lazy log` or check `~/.local/share/nvim/lazy.nvim/lazy.log`
3. Run health checks: `:checkhealth mason`, `:checkhealth lsp`

## Adding New Plugins

1. Create new file in `lua/custom/plugins/` (e.g., `my-plugin.lua`)
2. Return a lazy.nvim spec table
3. Restart Neovim or use `:Lazy reload`

Example:
```lua
-- lua/custom/plugins/my-plugin.lua
return {
  'author/plugin-name',
  config = function()
    require('plugin-name').setup()
  end,
}
```

## Adding New LSP Servers

1. Add server to the `servers` table in `lua/custom/plugins/lsp.lua`
2. Mason will auto-install on next restart (or run `:MasonToolsInstall`)
3. Add any server-specific configuration in the servers table

Example:
```lua
servers = {
  -- existing servers...
  gopls = {
    settings = {
      gopls = {
        analyses = { unusedparams = true },
      },
    },
  },
}
```

## Adding New Formatters

1. Add formatter to `ensure` list in `lua/custom/plugins/lsp.lua:54-59`
2. Add filetype mapping in `lua/custom/plugins/formatting.lua:6-12`
3. Format with `<leader>f` or save (if auto-save is enabled)

## Important Customizations

### Unique Settings in This Config

- **jj for Escape**: `jj` in insert mode maps to `<Esc>` (init.lua:73)
- **No Swap Files**: `vim.opt.swapfile = false` (init.lua:76)
- **No Comment Continuation**: Format option 'r' is removed to prevent auto-comment on new lines (init.lua:52-57)
- **UTF-16 Position Encoding**: Workaround for certain LSP servers at init.lua:35-40

### Custom Functions

The `lua/custom/functions.lua` file exports utilities like:
- `startThemeWatcher()`: Monitors macOS system theme and updates Neovim colorscheme
- `setThemeBasedOnOS()`: One-time theme sync based on OS theme

## Language Support

Currently configured LSP servers (from lsp.lua:13-37):
- C/C++: clangd
- Python: pyright
- Rust: rust_analyzer
- Kotlin: kotlin_language_server
- Zig: zls
- Docker: dockerls, docker_compose_language_service
- Java: jdtls
- Lua: lua_ls
- Swift/Objective-C: sourcekit (manual setup)

Formatters configured:
- Lua: stylua
- Rust: rustfmt
- C++: clang-format
- JavaScript: prettier
- Java: google-java-format

## Debugging

DAP (Debug Adapter Protocol) is configured in `lua/kickstart/plugins/debug.lua`:
- Supports Go, Rust (via codelldb), Scala, Kotlin
- Uses mason-nvim-dap for automatic adapter installation
- Debug keybindings start with `<leader>d`
