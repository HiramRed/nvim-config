return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- 大文件支持
      bigfile = { enabled = true },
      -- Dashboard 启动界面
      dashboard = { enabled = false },
      -- 快速文件跳转
      quickfile = { enabled = true },
      -- 更好的通知
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      -- 搜索高亮
      words = { enabled = true },
      -- 状态列
      statuscolumn = { enabled = true },
      -- Lazygit
      lazygit = { enabled = true },
      -- Explorer
      picker = {
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
            follow_file = false,
          },
        },
      },
    },
    keys = {
      -- find
      { "<leader>.", function() Snacks.dashboard() end, desc = "Dashboard" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      -- { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>ff", function() Snacks.picker.smart({ hidden = true,  ignored = false }) end, desc = "Smart Find Files" },
      -- { "<leader>ff", function() Snacks.picker.files({ hidden = true,  ignored = true }) end, desc = "Smart Find Files" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      { "<leader>F", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>fn", function() Snacks.picker.notifications() end, desc = "Notification History" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      -- { "<leader>fe", function() Snacks.picker.explorer() end, desc = "Explorer" },
      -- lsp
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "<leader>i", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "<leader>fo", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>fO", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      -- git
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      -- { "<leader>gl", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
      { "<leader>sg", function() Snacks.lazygit() end, desc = "Git Log File" },
      -- { "<leader>gh", function() Snacks.lazygit.log_file() end, desc = "Git Log File" },
    },
  },
}
