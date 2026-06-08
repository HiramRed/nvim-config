return {
  -- the colorscheme should be available when starting Neovim
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- vim.o.laststatus = 3
      vim.opt.fillchars = { horiz = "─" }
      vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#888888", bg = "NONE", bold = true })
      vim.api.nvim_set_hl(0, "VertSplit", { fg = "#888888", bg = "NONE", bold = true })
      -- vim.cmd([[colorscheme tokyonight]])
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    enabled = true,
    config = function()
      vim.cmd([[colorscheme catppuccin-nvim]])
    end,
  },
  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd([[colorscheme onedarkpro]])
    end,
  },
}
