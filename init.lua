-- Disable netrw and enable 24-bit color support
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.swapfile = false -- Disable swap files

-- Global variables and utilities
local map = vim.keymap.set
local fn = vim.fn
local cmd = vim.cmd
local g = vim.g

-- Set leader key to space
g.mapleader = ' '
g.maplocalleader = ' '

-- Line numbers and relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Lazy.nvim plugin manager setup
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
  -- Colorscheme
  { 'rose-pine/neovim', name = 'rose-pine' },

  -- Language support
  { 'mrcjkb/rustaceanvim', version = '^4', ft = { 'rust' } },
  { 'scalameta/nvim-metals', ft = { "scala", "sbt", "java" } },

  -- Utilities
  { 'christoomey/vim-tmux-navigator',
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
    { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
  },
  },
  { 'nvim-lua/popup.nvim' },
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' } },
  { 'hrsh7th/nvim-cmp', event = "InsertEnter", dependencies = { 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-vsnip', 'hrsh7th/vim-vsnip' } },
  { 'kyazdani42/nvim-tree.lua', dependencies = { 'kyazdani42/nvim-web-devicons' } },
  { 'neovim/nvim-lspconfig' },
  { 'williamboman/nvim-lsp-installer' },
  { 'mfussenegger/nvim-dap' },
  { 'lewis6991/gitsigns.nvim' },
})

-- Plugin configurations
require('nvim-tree').setup({}) -- File explorer
require('telescope').setup({ -- Fuzzy finder
  defaults = {
    mappings = { i = { ["<esc>"] = require('telescope.actions').close } },
    file_ignore_patterns = { "%.class$", "%.log$", "target/", "bloop/", "metals/", "project/project/", "project/target/" }
  },
})
require('gitsigns').setup({}) -- Git integration

-- Autocompletion setup
local cmp = require'cmp'
cmp.setup({
  snippet = { expand = function(args) fn["vsnip#anonymous"](args.body) end },
  mapping = cmp.mapping.preset.insert({ ['<CR>'] = cmp.mapping.confirm({ select = true }) }),
  sources = cmp.config.sources({ { name = 'nvim_lsp' }, { name = 'vsnip' } })
})

-- LSP setup
require('nvim-lsp-installer').setup({})
require'lspconfig'.rust_analyzer.setup({}) -- Rust LSP

-- Lua language server and autocompletion
local lspconfig = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
})

-- Metals (Scala LSP) setup
local metals_config = require("metals").bare_config()
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}

metals_config.on_attach = function(client, bufnr)
  require("metals").setup_dap() -- DAP integration

  -- LSP mappings
  map("n", "gD", vim.lsp.buf.definition)
  map("n", "K", vim.lsp.buf.hover)
  map("n", "gi", vim.lsp.buf.implementation)
  map("n", "gr", vim.lsp.buf.references)
  map("n", "gds", vim.lsp.buf.document_symbol)
  map("n", "gws", vim.lsp.buf.workspace_symbol)
  map("n", "<leader>cl", vim.lsp.codelens.run)
  map("n", "<leader>sh", vim.lsp.buf.signature_help)
  map("n", "<leader>rn", vim.lsp.buf.rename)
  map("n", "<leader>f", vim.lsp.buf.format)
  map("n", "<leader>ca", vim.lsp.buf.code_action)
  map("n", "<leader>ws", function() require("metals").hover_worksheet() end)

  -- Diagnostics mappings
  map("n", "<leader>aa", vim.diagnostic.setqflist) -- All workspace diagnostics
  map("n", "<leader>ae", function() vim.diagnostic.setqflist({ severity = "E" }) end) -- All workspace errors
  map("n", "<leader>aw", function() vim.diagnostic.setqflist({ severity = "W" }) end) -- All workspace warnings
  map("n", "<leader>d", vim.diagnostic.setloclist) -- Buffer diagnostics
  map("n", "[c", function() vim.diagnostic.goto_prev({ wrap = false }) end)
  map("n", "]c", function() vim.diagnostic.goto_next({ wrap = false }) end)

  -- DAP mappings
  map("n", "<leader>dc", function() require("dap").continue() end)
  map("n", "<leader>dr", function() require("dap").repl.toggle() end)
  map("n", "<leader>dK", function() require("dap.ui.widgets").hover() end)
  map("n", "<leader>dt", function() require("dap").toggle_breakpoint() end)
  map("n", "<leader>dso", function() require("dap").step_over() end)
  map("n", "<leader>dsi", function() require("dap").step_into() end)
  map("n", "<leader>dl", function() require("dap").run_last() end)

  local dap = require("dap")

          dap.configurations.scala = {
            {
              type = "scala",
              request = "launch",
              name = "RunOrTest",
              metals = {
                runType = "runOrTestFile",
                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
              },
            },
            {
              type = "scala",
              request = "launch",
              name = "Test Target",
              metals = {
                runType = "testTarget",
              },
            },
          }
end

local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback = function() require("metals").initialize_or_attach(metals_config) end,
  group = nvim_metals_group,
})

-- Custom keybindings
-- Exit insert mode
vim.api.nvim_set_keymap('i', 'jj', '<ESC>', { noremap = true, silent = true })

-- Telescope keybindings
map("n", "<leader>ff", ":Telescope find_files<cr>", { silent = true })
map("n", "<leader>fg", ":Telescope live_grep<cr>", { silent = true })
map("n", "<leader>fb", ":Telescope buffers<cr>", { silent = true })
map("n", "<leader>fh", ":Telescope help_tags<cr>", { silent = true })

-- Nvim-tree keybindings
map("n", "<leader>n", ":NvimTreeToggle<CR>", { silent = true })
map("n", "<leader>f", ":NvimTreeFindFile<CR>", { silent = true })

-- Clipboard support
vim.opt.clipboard = "unnamedplus"

-- Save and quit
local opts = { noremap = true, silent = true }
map('n', '<leader>w', ':w<CR>', opts) -- Save current buffer
map('n', '<leader>q', ':q<CR>', opts) -- Quit Neovim

-- Disable search highlighting on entering insert mode
vim.api.nvim_create_autocmd("InsertEnter", { pattern = "*", command = "set nohlsearch" })

-- Disable arrow keys in normal and visual mode
map('n', '<Up>', '<NOP>', opts)
map('n', '<Down>', '<NOP>', opts)
map('n', '<Left>', '<NOP>', opts)
map('n', '<Right>', '<NOP>', opts)
map('v', '<Up>', '<NOP>', opts)
map('v', '<Down>', '<NOP>', opts)
map('v', '<Left>', '<NOP>', opts)
map('v', '<Right>', '<NOP>', opts)

-- Faster window navigation
map('n', '<leader>h', '<C-w>h', opts)
map('n', '<leader>j', '<C-w>j', opts)
map('n', '<leader>k', '<C-w>k', opts)
map('n', '<leader>l', '<C-w>l', opts)

-- Quick access to terminal
map('n', '<leader>t', ':split | terminal<CR>', opts)

-- Toggle line numbering style
map('n', '<leader>ln', ':set invrelativenumber<CR>', opts)

-- Colorscheme
cmd("colorscheme rose-pine")
