return {
  {
    "Weissle/persistent-breakpoints.nvim",
    config = function()
      require("persistent-breakpoints").setup({
        load_breakpoints_event = { "BufReadPost" }, -- 打开文件时自动加载断点
      })

      local pb_api = require('persistent-breakpoints.api')

      -- 设置/取消断点 (替换原来的 dap.toggle_breakpoint)
      vim.keymap.set('n', '<leader>b', pb_api.toggle_breakpoint, { desc = "Toggle Breakpoint" })

      -- 设置条件断点 (替换原来的 dap.set_breakpoint)
      vim.keymap.set('n', '<leader>B', pb_api.set_conditional_breakpoint, { desc = "Conditional Breakpoint" })

      -- 清除当前文件的所有断点
      vim.keymap.set('n', '<leader>xb', pb_api.clear_all_breakpoints, { desc = "Clear All Breakpoints" })
    end,
  },
}
