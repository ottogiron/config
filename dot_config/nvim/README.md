# Neovim Config

A modular Neovim configuration based on kickstart.nvim, with opinions geared toward daily coding: fast navigation/search, sensible LSP defaults, Mason-managed tools, and a small set of quality-of-life plugins.

- Plugin manager: `lazy.nvim`
- Theme: `tokyonight` (auto-syncs with macOS light/dark)
- LSP: `nvim-lspconfig` + `mason.nvim`

## Features

- **Completion**: `nvim-cmp` with LSP support
- **Fuzzy finding**: `telescope.nvim` for files, grep, and more
- **LSP**: `nvim-lspconfig` + `mason.nvim` for go-to definition/references, rename, code actions
- **Formatting**: `conform.nvim` (format on demand via `<leader>f`)
- **Terminal**: `toggleterm.nvim` with smart window navigation
- **Git UI**: `neogit` for git operations
- **File tree**: `nvim-tree.nvim` sidebar
- **Zen mode**: `zen-mode.nvim` for distraction-free editing
- **Auto-save**: `auto-save.nvim` (disabled by default, configurable)
- **Keybinding discovery**: `which-key.nvim`
- **Markdown**: `render-markdown.nvim` for enhanced rendering
- **Multi-cursor**: `vim-visual-multi` for simultaneous editing
- **Autopairs**: `nvim-autopairs` for auto-closing brackets/quotes

## Requirements

- Neovim >= 0.9.4 (see `:checkhealth kickstart`)
- External tools (recommended): `git`, `make`, `unzip`, `rg`, `fd`
- A Nerd Font (optional, enables icons)

## QOL Commands

```bash
make fmt        # Apply stylua formatting
make fmt-check  # Verify formatting
```

## Installation

1. Backup your existing config:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

2. Clone this repository:

```bash
git clone https://github.com/ottogiron/nvim.git ~/.config/nvim
```

3. Start Neovim:

```bash
nvim
```

On first launch, Lazy will install plugins and Mason may install tools.

## Operational Notes

- Most LSP servers/formatters are installed via Mason on startup.
- `tokyonight` theme auto-sync uses `osascript` on macOS.

## Structure

```
~/.config/nvim/
├── init.lua
└── lua/
    ├── custom/
    │   ├── functions.lua
    │   └── plugins/
    └── kickstart/
```

- Add/modify plugins in `lua/custom/plugins/*.lua` (lazy.nvim specs).
- Reload custom modules in a running session with `<leader>rl`.

## Key Mappings

For a full list, inspect `lua/custom/plugins/which-key.lua` or use `:WhichKey`.

**General:**
- `<Space>` leader key
- `jj` escape from insert mode
- `<C-h/j/k/l>` window navigation
- `<Esc><Esc>` exit terminal-mode

**File Tree (nvim-tree):**
- `<leader>t` toggle file tree

**Search (telescope.nvim):**
- `<leader>sf` find files
- `<leader>sg` live grep
- `<leader>sn` search config files
- `<leader>sh` search help docs
- `<leader>sk` search keymaps

**LSP:**
- `gd` go to definition
- `gr` go to references
- `gI` go to implementation
- `K` hover documentation
- `<leader>rn` rename
- `<leader>ca` code action
- `<leader>ds` document symbols
- `<leader>ws` workspace symbols

**Editing:**
- `<leader>f` format buffer/selection (conform.nvim)
- Snippets (LuaSnip): `<Tab>` expand, `<S-Tab>` jump prev, `<C-k>` jump next, `<C-j>` jump prev
- `vim-visual-multi`: use plugin's default multi-cursor shortcuts

**Productivity:**
- `<leader>z` toggle zen mode
- `<leader>rl` reload custom modules

**Terminal (toggleterm.nvim):**
- `<C-q>` close terminal from terminal-mode
- Navigate splits with `<C-h/j/k/l>` in terminal

## Configuration

**Adding Plugins:**
Create new plugin specs in `lua/custom/plugins/`. After creating a file, reload with `:Lazy reload` or restart Neovim.

**Reloading Changes:**
- `<leader>rl` reload all custom modules
- `:source %` reload current file (in Neovim)
- Restart Neovim for major changes

**Per-Project Settings:**
Neovim loads `.nvim.lua` from project roots automatically (exrc enabled).

**Customizing Formatters:**
Edit `lua/custom/plugins/formatting.lua` to add/modify formatters. Mason auto-installs tools defined in `lua/custom/plugins/lsp.lua`, except servers not packaged by Mason (for example, Godot's built-in LSP).

**Notes:**
- Java files use 4-space indentation (via google-java-format)
- Auto-save is disabled by default (enable by editing `lua/custom/plugins/auto-save.lua`)

## Troubleshooting

- `:checkhealth` and `:checkhealth kickstart`
- `:Lazy` to inspect plugins
- `:Mason` to inspect tool installs

## Credits

- Based on kickstart.nvim: https://github.com/nvim-lua/kickstart.nvim
