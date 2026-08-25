local o = vim.opt
vim.g.mapleader = ' '          -- space is the leader key
o.expandtab = true             -- spaces, not tabs
o.shiftwidth = 2               -- 2 spaces per indent level
o.number = true                -- absolute number on the cursor line, relative elsewhere
o.relativenumber = true        -- relative line numbers for fast jumps
o.ignorecase = true            -- search is case-insensitive by default
o.smartcase = true             -- case-sensitive only if i type a capital
o.scrolloff = 16               -- keep cursor away from the screen edge
o.undofile = true              -- persistent undo across sessions
o.colorcolumn = '100'          -- vertical line marking the line-length limit

-- Don't paint a background color, so WezTerm's own (semi-transparent) background shows through,
-- the same way plain vi's unstyled 'Normal' group does. Reapply on every colorscheme change,
-- since colorschemes clear highlights and would otherwise overwrite this.
local function transparent_bg()
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = 'none' })
end
transparent_bg()
vim.api.nvim_create_autocmd('ColorScheme', { callback = transparent_bg })
