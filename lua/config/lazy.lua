-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- nvim-java
    -- {
    --   'nvim-java/nvim-java',
    --   config = function()
    --     require('java').setup()
    --     vim.lsp.enable('jdtls')
    --   end,
    -- },

    { import = 'plugins' },

    -- theme
    {
         "sickill/vim-monokai",
         enabled = not vim.g.vscode,
    },

    -- fzf(legacy) - fuzzy finder
    -- { "junegunn/fzf", build = ":call fzf#install()" },
    -- {
    --      "junegunn/fzf.vim",
    --      enabled = not vim.g.vscode,
    -- },

    -- session management
    { "xolox/vim-session", dependencies = { "xolox/vim-misc" } },
    { "xolox/vim-misc" },

    -- surround
    { "tpope/vim-surround" },

    -- coc.nvim - LSP (conditional loading)
    {
      "neoclide/coc.nvim",
      branch = "release",
      enabled = vim.g.coc_enable,
      -- enabled = not vim.g.vscode,
    },

    -- markdown preview
    {
      "iamcco/markdown-preview.nvim",
      build = "cd app && yarn install",
      ft = { "markdown" },
      enabled = not vim.g.vscode,
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { --[[ colorscheme = { "tokyonight" } ]] },
  -- automatically check for plugin updates
  checker = { enabled = false },
})
