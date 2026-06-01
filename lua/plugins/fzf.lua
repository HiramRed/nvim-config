return {
  {
    "ibhagwan/fzf-lua",
    -- enabled = not vim.g.vscode,
    enabled = false,  -- disabled in favor of telescope
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "nvim-mini/mini.icons" },
    ---@module "fzf-lua"
    ---@type fzf-lua.Config|{}
    ---@diagnostic disable: missing-fields
    config = function(_, opts)
      -- Move the require inside config function
      opts.lsp = opts.lsp or {}
      opts.lsp.jump1 = true
      opts.lsp.jump1_action = require("fzf-lua.actions").file_edit

      require('fzf-lua').setup(opts)
      -- vim.keymap.set('n', '<C-n>', ':FzfLua files resume=true<cr>', { silent = true })
      vim.keymap.set('n', '<C-n>', ':FzfLua files', { silent = true })

      -- LSP keymaps
      vim.keymap.set('n', 'gr', ':FzfLua lsp_references<cr>', { desc = 'LSP References' })
      vim.keymap.set('n', 'gd', ':FzfLua lsp_definitions<cr>', { desc = 'LSP Definitions' })
      vim.keymap.set('n', '<leader>i', ':FzfLua lsp_implementations<cr>', { desc = 'LSP Implementations' })
      vim.keymap.set('n', '<leader>u', ':FzfLua lsp_declarations<cr>', { desc = 'LSP Declarations' })
      vim.keymap.set('n', '<leader>dt', ':FzfLua lsp_typedefs<cr>', { desc = 'LSP Type Definitions' })
      vim.keymap.set('n', '<leader>do', ':FzfLua lsp_document_symbols<cr>', { desc = 'Document Symbols' })
      vim.keymap.set('n', '<leader>wo', ':FzfLua lsp_workspace_symbols<cr>', { desc = 'Workspace Symbols' })
      vim.keymap.set('n', '<leader>dl', ':FzfLua diagnostics_document<cr>', { desc = 'Document Diagnostics' })
      vim.keymap.set('n', '<leader>wl', ':FzfLua diagnostics_workspace<cr>', { desc = 'Workspace Diagnostics' })
      vim.keymap.set('n', '<leader>ca', ':FzfLua lsp_code_actions<cr>', { desc = 'Code Actions' })
      vim.keymap.set('n', '<leader>F', ':FzfLua grep regex<cr>', { desc = 'Grep' })
    end,
    opts = {}
  },
}
