return {
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },
    config = function()
      -- Advertise blink.cmp's completion capabilities to every server.
      vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
      })

      -- Machine-local LSP server config (see lua/lsp_local.lua.example).
      pcall(require, 'lsp_local')
    end,
  },
  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = {},  -- LSP progress spinners, useful with slow monorepo indexing
  },
}
