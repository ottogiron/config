return {
  'JavaHello/spring-boot.nvim',
  lazy = true, -- loaded by ftplugin/java.lua
  ft = { 'yaml', 'jproperties' }, -- auto-load for Spring config files
  dependencies = {
    'mfussenegger/nvim-jdtls',
  },
  opts = function()
    local mason_packages = vim.fn.stdpath 'data' .. '/mason/packages'
    local jar = vim.fn.glob(mason_packages .. '/vscode-spring-boot-tools/extension/language-server/spring-boot-language-server-*-exec.jar')
    return {
      ls_path = jar ~= '' and jar or nil,
    }
  end,
}
