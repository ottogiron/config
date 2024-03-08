-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true


-- Setting up global variables and utilities
local map = vim.keymap.set
local fn = vim.fn
local cmd = vim.cmd
local g = vim.g

-- Set leader key to space
g.mapleader = ' '
g.maplocalleader = ' '

vim.opt.number = true
vim.opt.relativenumber = true

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
      },
      opts = function()
     	local cmp = require("cmp")
      local conf = {
        sources = {
          { name = "nvim_lsp" },
          { name = "vsnip" },
        },
        snippet = {
          expand = function(args)
            -- Comes from vsnip
            fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          -- None of this made sense to me when first looking into this since there
          -- is no vim docs, but you can't have select = true here _unless_ you are
          -- also using the snippet stuff. So keep in mind that if you remove
          -- snippets you need to remove this select
          ["<CR>"] = cmp.mapping.confirm({ select = true })
        })
      }
      return conf
      end
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
  "scalameta/nvim-metals",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
	"j-hui/fidget.nvim",
	opts = {},
    },
    {
        "mfussenegger/nvim-dap",
        config = function(self, opts)
          -- Debug settings if you're using nvim-dap
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
      }
  },
  ft = { "scala", "sbt", "java" },
  opts = function()
    local metals_config = require("metals").bare_config()

    metals_config.settings = {
        showImplicitArguments = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      }

    metals_config.on_attach = function(client, bufnr)
      -- your on_attach function
      require("metals").setup_dap()

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

        map("n", "<leader>ws", function()
          require("metals").hover_worksheet()
        end)

        -- all workspace diagnostics
        map("n", "<leader>aa", vim.diagnostic.setqflist)

        -- all workspace errors
        map("n", "<leader>ae", function()
          vim.diagnostic.setqflist({ severity = "E" })
        end)

        -- all workspace warnings
        map("n", "<leader>aw", function()
          vim.diagnostic.setqflist({ severity = "W" })
        end)

        -- buffer diagnostics only
        map("n", "<leader>d", vim.diagnostic.setloclist)

        map("n", "[c", function()
          vim.diagnostic.goto_prev({ wrap = false })
        end)

        map("n", "]c", function()
          vim.diagnostic.goto_next({ wrap = false })
        end)

        -- Example mappings for usage with nvim-dap. If you don't use that, you can
        -- skip these
        map("n", "<leader>dc", function()
          require("dap").continue()
        end)

        map("n", "<leader>dr", function()
          require("dap").repl.toggle()
        end)

        map("n", "<leader>dK", function()
          require("dap.ui.widgets").hover()
        end)

        map("n", "<leader>dt", function()
          require("dap").toggle_breakpoint()
        end)

        map("n", "<leader>dso", function()
          require("dap").step_over()
        end)

        map("n", "<leader>dsi", function()
          require("dap").step_into()
        end)

        map("n", "<leader>dl", function()
          require("dap").run_last()
        end)
    end

    return metals_config
  end,
  config = function(self, metals_config)
    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = self.ft,
      callback = function()
        require("metals").initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
  end
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
require'nvim-tree'.setup {
}

-- Telescope setup
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = require('telescope.actions').close
      },
    },
    file_ignore_patterns = {"%.class$", "%.log$", "target/", "bloop/", "metals/", "project/project/", "project/target/"}
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
-- Map 'jj' to exit insert mode
vim.api.nvim_set_keymap('i', 'jj', '<ESC>', {noremap = true, silent = true})
map("n", "<leader>ff", ":Telescope find_files<cr>", {silent = true})
map("n", "<leader>fg", ":Telescope live_grep<cr>", {silent = true})
map("n", "<leader>fb", ":Telescope buffers<cr>", {silent = true})
map("n", "<leader>fh", ":Telescope help_tags<cr>", {silent = true})
map("n", "<leader>n", ":NvimTreeToggle<CR>", {silent = true})
map("n", "<leader>f", ":NvimTreeFindFile<CR>", {silent = true})

local opts = { noremap = true, silent = true }

-- Save the current buffer with "leader + w"
map('n', '<leader>w', ':w<CR>', opts)

-- Quit Neovim with "leader + q"
map('n', '<leader>q', ':q<CR>', opts)

vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  command = "set nohlsearch"
})


-- Disable Arrow Keys in Normal and Visual Mode
map('n', '<Up>', '<NOP>', opts)
map('n', '<Down>', '<NOP>', opts)
map('n', '<Left>', '<NOP>', opts)
map('n', '<Right>', '<NOP>', opts)
map('v', '<Up>', '<NOP>', opts)
map('v', '<Down>', '<NOP>', opts)
map('v', '<Left>', '<NOP>', opts)
map('v', '<Right>', '<NOP>', opts)

-- Faster Window Navigation
map('n', '<leader>h', '<C-w>h', opts)
map('n', '<leader>j', '<C-w>j', opts)
map('n', '<leader>k', '<C-w>k', opts)
map('n', '<leader>l', '<C-w>l', opts)


-- Quick access to terminal
map('n', '<leader>t', ':split | terminal<CR>', opts)

-- Toggle line numbering style with "leader + ln"
map('n', '<leader>ln', ':set invrelativenumber<CR>', opts)



-- Configure <leader> keybindings for common LSP functions
map("n", "<leader>ld", ":lua vim.lsp.buf.definition()<CR>", {silent = true})
map("n", "<leader>lh", ":lua vim.lsp.buf.hover()<CR>", {silent = true})
map("n", "<leader>lr", ":lua vim.lsp.buf.rename()<CR>", {silent = true})
map("n", "<leader>la", ":lua vim.lsp.buf.code_action()<CR>", {silent = true})

-- Colorscheme
cmd("colorscheme rose-pine")


-- Nvim tree
require("nvim-tree").setup()
