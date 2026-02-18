return {
  'projekt0n/github-nvim-theme',
  dependencies = {
    'folke/tokyonight.nvim',
  },
  lazy = false,
  priority = 1000,
  config = function()
    -- Setup github theme first (required before using its colorschemes)
    require('github-theme').setup()

    require('tokyonight').setup {
      transparent = false,
      style = 'night', -- night, storm, moon, or day
    }

    local themeWatcher = require 'custom.functions'

    -- Start theme watcher (sets initial theme internally)
    -- Interval: 180000ms = 3 minutes (reduced from 60s for efficiency)
    themeWatcher.startThemeWatcherWithOptions {
      interval = 180000,
      darkTheme = 'github_dark_default',
      lightTheme = 'github_dark_default',
    }
  end,
}
