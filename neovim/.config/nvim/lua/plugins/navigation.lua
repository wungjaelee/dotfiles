return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      picker = { enabled = true },
      notifier = { enabled = true },
      input = { enabled = true },
      bigfile = { enabled = true },
    },
    keys = {
      { '<leader>f', function() Snacks.picker.files({ hidden = true }) end, desc = 'Find Files' },
      { '<leader>s', function() Snacks.picker.grep({ hidden = true }) end,  desc = 'Search Text' },
      { '<leader>b', function() Snacks.picker.buffers() end, desc = 'Buffers' },
      { '<leader>l', function() Snacks.picker.lines() end, desc = 'Search Lines' },
      { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition' },
    },
  },
}
