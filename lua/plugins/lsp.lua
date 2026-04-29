-- LSP Configuration
return {
  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "ts_ls" },
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- TypeScript/JavaScript (ts_ls is the new name for tsserver)
      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
      })
      vim.lsp.enable("ts_ls")

      -- LSP key mappings
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
    end,
  },

  -- Mason
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      vim.keymap.set("n", "<leader>lm", ':Mason<cr>', { desc = "Open Mason manager window" })
    end,
  },

  -- Mason LSP Config
  {
    "williamboman/mason-lspconfig.nvim",
  },
}
