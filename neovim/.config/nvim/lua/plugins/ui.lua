return {
  {
    'folke/which-key.nvim',
    lazy = false,
    config = true,  -- popup that shows what my leader keys do
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
        },
      },
      presets = {
        bottom_search = true,
        long_message_to_split = true,
      },
      -- Snacks already owns notifications; let noice handle cmdline/messages/popupmenu only
      notify = { enabled = false },
    },
  },
}
