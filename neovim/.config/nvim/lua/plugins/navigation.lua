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
      terminal = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = ' ', key = 'f', desc = 'Find File', action = function() Snacks.picker.files({ hidden = true }) end },
            { icon = ' ', key = 'r', desc = 'Recent Files', action = function() Snacks.picker.recent() end },
            { icon = ' ', key = 's', desc = 'Search Text', action = function() Snacks.picker.grep({ hidden = true }) end },
            { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
          },
        },
        sections = {
          { section = 'header' },
          { section = 'keys', gap = 1, padding = 1 },
          { section = 'recent_files', limit = 8, padding = 1 },
          { section = 'startup' },
        },
      },
    },
    keys = {
      { '<leader>f', function() Snacks.picker.files({ hidden = true }) end, desc = 'Find Files' },
      { '<leader>s', function() Snacks.picker.grep({ hidden = true }) end,  desc = 'Search Text' },
      { '<leader>b', function() Snacks.picker.buffers() end, desc = 'Buffers' },
      { '<leader>l', function() Snacks.picker.lines() end, desc = 'Search Lines' },
      { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition' },
      -- bare Snacks.terminal() defaults to a bottom split; force float explicitly
      { '<leader>t', function() Snacks.terminal(nil, { win = { position = 'float' } }) end, desc = 'Toggle Floating Terminal' },
    },
  },
}
