-- pane navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left pane' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to below pane' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to above pane' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right pane' })

-- exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- save by pressing Escape
vim.keymap.set('n', '<Esc>', ':w<CR>', { desc = 'Save' })
-- pasting over a selection no longer clobbers your clipboard
vim.cmd([[ xnoremap <expr> p 'pgv"'.v:register.'y' ]])
