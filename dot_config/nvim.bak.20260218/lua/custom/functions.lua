local uv = vim.uv -- Updated from vim.loop to vim.uv

local function isMacOS()
  return uv.os_uname().sysname == 'Darwin'
end

local function getMacOSTheme(darkTheme, lightTheme)
  -- Use defaults command which is more reliable than osascript
  local handle = io.popen 'defaults read -g AppleInterfaceStyle 2>/dev/null'
  if not handle then
    vim.notify('Theme watcher: Failed to get macOS theme', vim.log.levels.WARN)
    return lightTheme
  end

  local result = handle:read '*a'
  handle:close()

  -- If AppleInterfaceStyle is set to "Dark", it's dark mode
  -- If the key doesn't exist (empty result), it's light mode
  if result and string.find(result, 'Dark') then
    return darkTheme
  else
    return lightTheme
  end
end

local function setThemeBasedOnOS(darkTheme, lightTheme)
  local themeToSet
  if isMacOS() then
    themeToSet = getMacOSTheme(darkTheme, lightTheme)
  else
    themeToSet = darkTheme -- default to the dark theme on non-macOS systems
  end
  vim.cmd('colorscheme ' .. themeToSet)
end

local function startThemeWatcher(interval, darkTheme, lightTheme)
  local timer = uv.new_timer()
  timer:start(
    0,
    interval,
    vim.schedule_wrap(function()
      setThemeBasedOnOS(darkTheme, lightTheme)
    end)
  )

  -- Auto-cleanup on Neovim exit
  vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = function()
      if timer then
        timer:stop()
        timer:close()
      end
    end,
  })

  -- Return a function to stop the timer manually if needed
  return function()
    timer:stop()
    timer:close()
  end
end

-- Enhanced version with options table
local function startThemeWatcherWithOptions(options)
  options = options or {}
  local interval = options.interval
  local darkTheme = options.darkTheme
  local lightTheme = options.lightTheme

  -- Set initial theme immediately before starting watcher
  setThemeBasedOnOS(darkTheme, lightTheme)

  return startThemeWatcher(interval, darkTheme, lightTheme)
end

return {
  startThemeWatcher = startThemeWatcher,
  startThemeWatcherWithOptions = startThemeWatcherWithOptions,
  setThemeBasedOnOS = setThemeBasedOnOS, -- Exported for one-time use
}
