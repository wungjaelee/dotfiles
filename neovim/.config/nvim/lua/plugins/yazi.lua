return {
  'mikavilpas/yazi.nvim',
  dependencies = { 'folke/snacks.nvim' },
  lazy = true,
  keys = {
    { '<leader>e', '<cmd>Yazi<cr>',        desc = 'Yazi (current file)' },
    { '<leader>E', '<cmd>Yazi cwd<cr>',    desc = 'Yazi (cwd)' },
  },
  opts = {
    open_for_directories = true,  -- open yazi instead of netrw when opening a directory
    -- yazi.nvim defaults these to telescope, which isn't installed; use the snacks picker.
    -- In yazi, <c-s> greps the hovered directory (or the selected files).
    integrations = {
      grep_in_directory = 'snacks.picker',
      grep_in_selected_files = 'snacks.picker',
    },
  },
}
