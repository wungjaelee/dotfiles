-- Use the real system clipboard where one is reachable (macOS, Linux with
-- xclip/xsel/wl-copy). Otherwise, over SSH, fall back to OSC 52 for copy
-- only: OSC 52 paste needs the terminal to answer a query, which most
-- terminals refuse for security reasons, so wiring it risks a multi-second
-- hang on every paste. <leader>y (not unnamedplus) keeps plain yanks/deletes
-- from paying for a clipboard round-trip they didn't ask for.
--
-- NOTE: detection must use executable(), not has('clipboard') — calling
-- has('clipboard') runs and caches Neovim's own provider check, and if that
-- happens before vim.g.clipboard below is set, the negative result sticks
-- for the rest of the session even after we set a provider.
local function has_native_clipboard()
  return vim.fn.executable('pbcopy') == 1
    or vim.fn.executable('wl-copy') == 1
    or vim.fn.executable('xclip') == 1
    or vim.fn.executable('xsel') == 1
end

if has_native_clipboard() then
  vim.opt.clipboard = 'unnamedplus'
elseif vim.env.SSH_TTY then
  local osc52 = require('vim.ui.clipboard.osc52')
  vim.g.clipboard = {
    name = 'OSC 52 (copy only)',
    copy = { ['+'] = osc52.copy('+'), ['*'] = osc52.copy('*') },
    paste = { ['+'] = function() return {} end, ['*'] = function() return {} end },
  }
  vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
end
