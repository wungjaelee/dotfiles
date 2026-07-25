return {
  'mikavilpas/yazi.nvim',
  dependencies = { 'folke/snacks.nvim' },
  lazy = true,
  keys = {
    { '<leader>y', '<cmd>Yazi<cr>',        desc = 'Yazi (current file)' },
    { '<leader>Y', '<cmd>Yazi cwd<cr>',    desc = 'Yazi (cwd)' },
  },
  opts = {
    open_for_directories = true,  -- open yazi instead of netrw when opening a directory
  },
}
