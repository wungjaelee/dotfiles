return {
  {
    'NeogitOrg/neogit',
    dependencies = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' },
    keys = { { '<leader>g', function() require('neogit').open() end, desc = 'Neogit' } },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufWinEnter',
    opts = { current_line_blame = true },  -- who last touched this line
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose' },
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
    },
  },
}
