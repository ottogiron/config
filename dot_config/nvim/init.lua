--[[
Neovim Configuration
===================

This configuration is based on kickstart.nvim but has been customized and modularized.
The configuration is split into the following structure:

Core Settings (/init.lua):
- Basic Neovim settings
- Key mappings
- Autocommands
- Plugin management (lazy.nvim)

Plugin Configurations (/lua/custom/plugins/):
- LSP configuration (lsp.lua)
- Completion setup (completion.lua)
- Telescope setup (telescope.lua)
- Code formatting (formatting.lua)
- Additional plugin configs

Quick Reference:
- :Lazy - Manage plugins
- :Mason - Manage LSP servers, formatters, and linters
- :checkhealth - Diagnose issues
- :help - Built-in documentation
- <space>sh - Search help documentation
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
--
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.filetype.add({
  extension = {
    flux = 'flux',
  },
})

-- Reload custom modules
vim.keymap.set('n', '<leader>rl', function()
  -- Only reload core custom modules (not plugins, which lazy.nvim handles)
  local modules_to_reload = {
    'custom.functions',
    'custom.lsp-utils',
  }
  local failed_modules = {}
  for _, module in ipairs(modules_to_reload) do
    package.loaded[module] = nil
    local ok, err = pcall(require, module)
    if not ok then
      table.insert(failed_modules, module .. ': ' .. err)
    end
  end
  if #failed_modules == 0 then
    vim.notify('Custom modules reloaded!', vim.log.levels.INFO)
  else
    vim.notify('Failed to reload: ' .. table.concat(failed_modules, ', '), vim.log.levels.ERROR)
  end
end, { desc = '[R]e[l]oad custom modules' })

-- Don't auto insert comment after new line in insert mode
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('format-options', { clear = true }),
  pattern = '*',
  callback = function()
    vim.opt.formatoptions:remove { 'r' }
  end,
})

-- Load local local nvim per-project configuration

vim.o.exrc = true
vim.o.secure = true

-- Use PowerShell on Windows
if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
  vim.opt.shell = 'pwsh.exe'
  vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'
  vim.opt.shellquote = ''
  vim.opt.shellxquote = ''
end

-- Use jj for <ESC>
vim.keymap.set('i', 'jj', '<Esc>', { silent = true })

-- Disable swap files because we only live once
vim.opt.swapfile = false

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Set TABS
-- minimal init.lua for indentation
vim.cmd [[filetype plugin indent on]] -- per-language indent rules

vim.opt.autoindent = true -- copy indent from previous line
vim.opt.smartindent = true -- C-like smart indent
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.shiftwidth = 2 -- spaces per indent level
vim.opt.tabstop = 2 -- spaces per tab
vim.opt.softtabstop = 2 -- spaces per tab while editing

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, for help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- Use 'unnamed' for macOS (pbcopy/pbpaste) and 'unnamedplus' for Linux
vim.opt.clipboard = 'unnamed,unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', 'jj', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Terminal mode: escape first, then navigate
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Move focus to the left window' })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = 'Move focus to the lower window' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Move focus to the upper window' })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Move focus to the right window' })
vim.keymap.set('t', '<C-A-l>', 'clear<CR>', { desc = 'Clear terminal screen' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
local uv = vim.uv or vim.loop -- Fallback for older Neovim versions
if not uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Load plugins from custom/plugins directory
require('lazy').setup('custom.plugins', {
  change_detection = {
    notify = false,
  },
})
