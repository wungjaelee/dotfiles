return {
  {
    'NeogitOrg/neogit',
    dependencies = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' },
    keys = { { '<leader>gg', function() require('neogit').open() end, desc = 'Neogit' } },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufWinEnter',
    opts = { current_line_blame = true },  -- who last touched this line
    keys = {
      {
        '<leader>gp',
        function()
          local file = vim.fn.expand('%')
          local line = vim.fn.line('.')
          local blame = vim.fn.systemlist({ 'git', 'blame', '-L', line .. ',' .. line, '--porcelain', file })
          if vim.v.shell_error ~= 0 then
            vim.notify('Not a git-tracked file', vim.log.levels.ERROR)
            return
          end
          local sha = blame[1]:match('^(%x+)')
          if sha:match('^0+$') then
            vim.notify('Line has no commit yet', vim.log.levels.WARN)
            return
          end
          -- {owner}/{repo} are resolved by gh from the current repo's remote
          local url = vim.fn.system({ 'gh', 'api', 'repos/{owner}/{repo}/commits/' .. sha .. '/pulls', '--jq', '.[0].html_url' })
          url = vim.trim(url)
          if vim.v.shell_error ~= 0 or url == '' then
            vim.notify('No PR found for commit ' .. sha:sub(1, 7), vim.log.levels.WARN)
            return
          end
          vim.fn.setreg('+', url)
          vim.notify('Copied PR URL: ' .. url)
        end,
        desc = 'Copy PR URL for current line',
      },
      {
        '<leader>gb',
        function() require('gitsigns').blame_line({ full = true }) end,
        desc = 'Blame current line (full)',
      },
      {
        '<leader>gB',
        function() require('gitsigns').blame() end,
        desc = 'Blame buffer',
      },
    },
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
    keys = {
      {
        '<leader>gv',
        function()
          -- A...B rev-ranges pin both sides to read-only git blobs, so diff against
          -- the merge-base as a single rev instead - that keeps the working tree side editable.
          local merge_base = vim.fn.systemlist({ 'git', 'merge-base', '@{upstream}', 'HEAD' })[1]
          if vim.v.shell_error ~= 0 or not merge_base then
            vim.notify('No tracking branch configured for this branch', vim.log.levels.ERROR)
            return
          end
          vim.cmd('DiffviewOpen ' .. merge_base)
        end,
        desc = 'Diffview vs tracking branch',
      },
      {
        '<leader>gh',
        ':DiffviewFileHistory<CR>',
        mode = 'v',
        desc = 'Git history for selected lines',
      },
    },
  },
}
