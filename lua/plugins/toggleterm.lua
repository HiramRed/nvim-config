return {
  -- toggle terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    enabled = not vim.g.vscode,
    opts = {
      open_mapping = [[<c-\>]],
      direction = 'float',
    },
  },
}
