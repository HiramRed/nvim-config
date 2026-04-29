return {
  {
    'smoka7/hop.nvim',
    version = "*",
    config = function(_, opts)
      -- NvimTree keymap
      require('hop').setup(opts)
      vim.keymap.set('n', 's', ':HopChar2<cr>', { silent = true })
    end,
    opts = {
      keys = 'etovxqpdygfblzhckisuran'
    }
  }
}
