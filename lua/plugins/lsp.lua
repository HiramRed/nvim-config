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
        ensure_installed = { "vtsls", "vue_ls", "eslint" },
      })

      local capabilities = require("blink.cmp").get_lsp_capabilities()
      -- local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Vue (vue_ls)
      vim.lsp.config("vue_ls", {
        capabilities = capabilities,
      })

      -- 配置vtsls以支持Vue
      local vue_language_server_path = vim.fn.stdpath('data') .. "/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin"
      local vue_plugin = {
        name = '@vue/typescript-plugin',
        location = vue_language_server_path,
        languages = { 'vue' },
        configNamespace = 'typescript',
      }

      -- TypeScript/JavaScript (ts_ls is the new name for tsserver)
      vim.lsp.config("vtsls", {
        capabilities = capabilities,
        filetypes = {
          "typescript",
          "javascript",
          "javascript.jsx",
          "typescript.jsx",
          "javascriptreact",
          "typescriptreact",
          "vue",
        },
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                vue_plugin,
              },
            },
          },
        },
      })

      vim.lsp.config("eslint", {
        capabilities = capabilities,
        filetypes = {
          "javascript", "javascriptreact", "javascript.jsx",
          "typescript", "typescriptreact", "typescript.tsx",
          "vue", "css", "html", "json", "jsonc", "yaml"
        },
        -- on_attach = function(client, bufnr)
        --   -- 监听 BufWritePre 事件（保存前触发）
        --   vim.api.nvim_create_autocmd("BufWritePre", {
        --     buffer = bufnr,     -- 只针对当前 buffer 生效
        --     command = "LspEslintFixAll", -- 执行 ESLint 提供的修复命令
        --   })
        -- end,
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

      local opts = { noremap = true, silent = true }

      -- Enable LSPs
      vim.lsp.enable("vtsls", "vue_ls", "lua_ls")

      vim.api.nvim_create_user_command('LspInfo', ':checkhealth vim.lsp', { desc = 'Alias to `:checkhealth vim.lsp`' })

      -- LSP key mappings (non-fzf ones)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
      -- Jump to diagnostics with severity priority: ERROR > WARN > INFO > HINT
      local function diagnostic_goto(direction)
        local severities = {
          vim.diagnostic.severity.ERROR,
          vim.diagnostic.severity.WARN,
          vim.diagnostic.severity.INFO,
          vim.diagnostic.severity.HINT,
        }
        local goto_fn = direction == "next" and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
        for _, sev in ipairs(severities) do
          local ok, _ = pcall(goto_fn, { severity = { min = sev, max = sev } })
          if ok then return end
        end
        vim.notify("No diagnostics found", vim.log.levels.INFO)
      end
      vim.keymap.set("n", "[g", function() diagnostic_goto("prev") end, { desc = "Previous diagnostic (error priority)" })
      vim.keymap.set("n", "]g", function() diagnostic_goto("next") end, { desc = "Next diagnostic (error priority)" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, opts)
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
