return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "nvim-mini/mini.icons" },
    ---@module "fzf-lua"
    ---@type fzf-lua.Config|{}
    ---@diagnostic disable: missing-fields
    -- enabled = not vim.g.vscode,
    config = function(_, opts)
      -- NvimTree keymap
      require('fzf-lua').setup(opts)
      vim.keymap.set('n', '<C-n>', ':FzfLua files resume=true<cr>', { silent = true })
    end,
    opts = {}
  },
}
