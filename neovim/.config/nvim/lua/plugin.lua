local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup('plugins', {  -- load every file in lua/plugins/
  rocks = { enabled = false },
  performance = {
    rtp = {
      -- uber-neovim ships compiled treesitter parsers (markdown, lua, ...) here
      -- but doesn't add it to runtimepath itself, so lazy's rtp reset must re-add it
      paths = { '/usr/lib/nvim' },
    },
  },
})
