return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" }, -- 延迟加载，打开文件时才启用
    config = function()
      local conform = require("conform")

      conform.setup({
        -- 【核心配置1】定义每种文件类型对应的 formatter
        -- 这里的名字必须和 Mason 中显示的名字一致！
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "isort", "black" }, -- 可以链式调用，先 isort 再 black
          javascript = { "prettier" },
          typescript = { "prettier" },
          java = { "clang-format" },
          vue = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          json = { "prettier" },
          markdown = { "prettier" },
          go = { "gofmt" },
          -- 如果你想对所有没有专门配置的文件使用 prettier，可以配置：
          -- ["*"] = { "prettier" },
        },

        -- 【核心配置2】保存时自动格式化（非常推荐）
        -- format_on_save = {
        --   timeout_ms = 500, -- 格式化超时时间，避免大文件卡顿
        --   lsp_fallback = true, -- 如果没有配置 conform 的 formatter，回退使用 LSP 提供的格式化能力
        -- },
      })

      -- 【核心配置3】设置手动格式化的快捷键
      -- 在 Normal 模式下按 <leader>f 格式化当前文件
      vim.keymap.set({ "n", "v" }, "<leader>fm", function()
        conform.format({
          lsp_fallback = false,
          async = false, -- false 表示同步执行，格式化完成前会卡住一下；true 表示异步
          timeout_ms = 500,
        })
      end, { desc = "Format file or range (in visual mode)" })
    end,
  },
}
