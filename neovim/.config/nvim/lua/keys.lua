-- pane navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left pane' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to below pane' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to above pane' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right pane' })

-- splits
vim.keymap.set('n', '<leader>v', '<cmd>vsplit<cr><C-w>l', { desc = 'Vertical split' })
vim.keymap.set('n', '<leader>x', '<cmd>split<cr><C-w>j', { desc = 'Horizontal split' })
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>', { desc = 'Close pane' })
vim.keymap.set('n', '<leader>w', '<cmd>bd<cr>', { desc = 'Close buffer' })

-- exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- q wipes a plain :term buffer once in normal mode, revealing whatever was open before
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function(args)
    if vim.bo[args.buf].filetype == 'snacks_terminal' then
      return  -- snacks.nvim already manages its own close/hide keymap
    end
    vim.keymap.set('n', 'q', '<cmd>bd!<CR>', { buffer = args.buf, desc = 'Close terminal' })
  end,
})

-- comment toggle
vim.keymap.set('n', '<leader>/', 'gcc', { desc = 'Toggle comment', remap = true })
vim.keymap.set('v', '<leader>/', 'gc', { desc = 'Toggle comment', remap = true })

-- save by pressing Escape
vim.keymap.set('n', '<Esc>', ':w<CR>', { desc = 'Save' })
-- pasting over a selection no longer clobbers your clipboard
vim.cmd([[ xnoremap <expr> p 'pgv"'.v:register.'y' ]])

-- replace word under cursor, or visual selection, everywhere in the file
vim.keymap.set('n', '<leader>r', [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], { desc = 'Replace word under cursor' })
vim.keymap.set('v', '<leader>r', [["hy:%s/\V<C-r>=escape(@h, '/\')<CR>//g<Left><Left>]], { desc = 'Replace selection' })
