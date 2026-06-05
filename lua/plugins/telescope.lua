return {
  {
    'nvim-telescope/telescope.nvim', version = '*',
    enabled = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- optional but recommended
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function(_, opts)
      local builtin = require('telescope.builtin')
      -- vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      -- vim.keymap.set('n', '<leader>F', builtin.live_grep, { desc = 'Telescope live grep' })
      -- vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fm', builtin.marks, { desc = 'Telescope book marks' })
    end,
  },
}
