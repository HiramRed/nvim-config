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
        ensure_installed = { "vtsls", "vue_ls" },
      })

      local capabilities = require("blink.cmp").get_lsp_capabilities()
      -- local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Vue (vue_ls)
      vim.lsp.config("vue_ls", {
        capabilities = capabilities,
      })

      -- 配置vtsls以支持Vue
      local vue_language_server_path = vim.fn.stdpath('data') .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
      local vue_plugin = {
        name = '@vue/typescript-plugin',
        location = vue_language_server_path,
        languages = { 'vue' },
        configNamespace = 'typescript',
      }

      -- TypeScript/JavaScript (ts_ls is the new name for tsserver)
      vim.lsp.config("vtsls", {
        capabilities = capabilities,
        filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
        settings = {
          vue = {
            target = 2,
          },
          vtsls = {
            tsserver = {
              globalPlugins = {
                vue_plugin,
              },
            },
          },
        },
      })

      -- Lua LSP (disable auto-creation of .luarc.json)
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
              -- 禁用自动创建 .luarc.json
              maxPreload = 1000,
              preloadFileSize = 100,
            },
            telemetry = { enable = false },
          },
        },
      })

      -- Enable LSPs
      vim.lsp.enable("vtsls", "vue_ls", "lua_ls")

      -- LSP key mappings (non-fzf ones)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
      vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
      vim.keymap.set("n", "]g", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
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
