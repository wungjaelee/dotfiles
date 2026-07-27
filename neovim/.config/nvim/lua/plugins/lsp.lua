return {
  {
    'neovim/nvim-lspconfig',
    config = function()
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
