-- Setting up global variables and utilities
local map = vim.keymap.set
local fn = vim.fn
local cmd = vim.cmd
local g = vim.g

-- Set leader key to space
g.mapleader = ' '
g.maplocalleader = ' '

-- Lazy.nvim setup
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.runtimepath:append(lazypath)

-- Plugin setup
require("lazy").setup({
  {
      'rose-pine/neovim',
      name = 'rose-pine'
  },
  {
      'mrcjkb/rustaceanvim',
      version = '^4',
      ft = { 'rust' }
  },
  {
      'christoomey/vim-tmux-navigator'
  },
  {
      'nvim-lua/popup.nvim'
  },
  {
      'nvim-lua/plenary.nvim'
  },
  {
      'nvim-telescope/telescope.nvim',
      dependencies = {
          'nvim-lua/popup.nvim',
          'nvim-lua/plenary.nvim'
      }
  },
  {
      'hrsh7th/nvim-cmp',
      event = "InsertEnter",
      dependencies = {
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/cmp-vsnip',
          'hrsh7th/vim-vsnip'
      }
  },
  {
      'kyazdani42/nvim-tree.lua',
      dependencies = {
          'kyazdani42/nvim-web-devicons' -- for file icons
      }
  },
  {
      'neovim/nvim-lspconfig' -- LSP Configuration
  },
  {
      'williamboman/nvim-lsp-installer' -- Simplified LSP installer
  },
  {
      'mfussenegger/nvim-dap' -- Debugging (DAP)
  },
  {
      'lewis6991/gitsigns.nvim' -- Git integration
  },
})

-- Nvim-tree setup
require'nvim-tree'.setup {}

-- Telescope setup
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = require('telescope.actions').close
      },
    },
  },
}

-- Gitsigns setup
require('gitsigns').setup {}

-- LSP settings (example for Rust, extend as needed)
require('nvim-lsp-installer').setup {}
require'lspconfig'.rust_analyzer.setup {}

-- Nvim-cmp setup for autocompletion
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({ select = true })
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  })
})

-- Custom keybindings
map("n", "<leader>ff", ":Telescope find_files<cr>", {silent = true})
map("n", "<leader>fg", ":Telescope live_grep<cr>", {silent = true})
map("n", "<leader>fb", ":Telescope buffers<cr>", {silent = true})
map("n", "<leader>fh", ":Telescope help_tags<cr>", {silent = true})
map("n", "<leader>n", ":NvimTreeToggle<CR>", {silent = true})
map("n", "<leader>f", ":NvimTreeFindFile<CR>", {silent = true})

-- Configure <leader> keybindings for common LSP functions
map("n", "<leader>ld", ":lua vim.lsp.buf.definition()<CR>", {silent = true})
map("n", "<leader>lh", ":lua vim.lsp.buf.hover()<CR>", {silent = true})
map("n", "<leader>lr", ":lua vim.lsp.buf.rename()<CR>", {silent = true})
map("n", "<leader>la", ":lua vim.lsp.buf.code_action()<CR>", {silent = true})

-- Colorscheme
cmd("colorscheme rose-pine")
