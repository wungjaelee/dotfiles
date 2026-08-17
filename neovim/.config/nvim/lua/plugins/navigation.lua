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
      zen = { enabled = true },
      indent = { enabled = true },
      quickfile = { enabled = true },
      gitbrowse = {
        enabled = true,
        -- Fall back to copying the URL when there's no real browser to open it (e.g.
        -- a devpod/container) - vim.ui.open()'s xdg-open exit code tells us it failed.
        open = function(url)
          local cmd, err = vim.ui.open(url)
          if not cmd then
            vim.fn.setreg('+', url)
            vim.notify('No opener found (' .. err .. ') - copied URL to clipboard', vim.log.levels.WARN)
            return
          end
          local result = cmd:wait()
          if result.code ~= 0 then
            vim.fn.setreg('+', url)
            vim.notify('No browser available - copied URL to clipboard', vim.log.levels.WARN)
          end
        end,
        -- Snacks replaces (not merges) this whole list when overridden, so the full
        -- upstream default set is duplicated here with one addition: Uber's gitolite
        -- remotes look like `gitolite@host:repo`, which none of the built-in
        -- `^git@...` patterns match (they require the literal prefix `git@`).
        remote_patterns = {
          { '^(https?://.*)%.git$', '%1' },
          { '^git@(.+):(.+)%.git$', 'https://%1/%2' },
          { '^git@(.+):(.+)$', 'https://%1/%2' },
          { '^git@(.+)/(.+)$', 'https://%1/%2' },
          { '^org%-%d+@(.+):(.+)%.git$', 'https://%1/%2' },
          { '^ssh://git@(.*)$', 'https://%1' },
          { '^ssh://([^:/]+)(:%d+)/(.*)$', 'https://%1/%3' },
          { '^ssh://([^/]+)/(.*)$', 'https://%1/%2' },
          { 'ssh%.dev%.azure%.com/v3/(.*)/(.*)$', 'dev.azure.com/%1/_git/%2' },
          { '^https://%w*@(.*)', 'https://%1' },
          { '^git@(.*)', 'https://%1' },
          { ':%d+', '' },
          { '%.git$', '' },
          -- Uber's go-code gitolite remote -> its Sourcegraph browse URL
          { '^gitolite@code%.uber%.internal:go%-code$', 'https://sg.uberinternal.com/r/code.uber.internal/uber-code/go-code' },
        },
        url_patterns = {
          ['sg%.uberinternal%.com'] = {
            branch = '/-/tree/{branch}',
            file = '/-/blob/{branch}/{file}#L{line_start}',
            permalink = '/-/blob/{commit}/{file}#L{line_start}',
            commit = '/-/commit/{commit}',
          },
        },
      },
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
      { '<leader>z', function() Snacks.zen() end, desc = 'Toggle Zen Mode' },
      { '<leader>o', function() Snacks.gitbrowse({ what = 'file' }) end, desc = 'Open current line in browser' },
    },
  },
}
