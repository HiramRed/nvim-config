return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  enabled = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({
          source = "filesystem",
          reveal = false,
          position = "left",
          toggle = false,
          focus = true,
        })
      end,
      desc = "Explorer (reveal current file)",
    },
    {
      "<leader>ss",
      function()
        require("neo-tree.command").execute({
          source = "filesystem",
          reveal_force_cwd = true,
        })
      end,
      desc = "Reveal current file",
    },
  },
  opts = {
    close_if_last_window = false,

    popup_border_style = "rounded",

    enable_git_status = true,
    enable_diagnostics = true,

    filesystem = {
      follow_current_file = {
        enabled = false, -- 不自动跟随
      },

      hijack_netrw_behavior = "open_default",

      filtered_items = {
        visible = true,

        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
      },

      window = {
        mappings = {
          --------------------------------------------------
          -- NERDTree风格
          --------------------------------------------------
          ["o"] = "open",

          -- ["p"] = "navigate_up",

          --------------------------------------------------
          -- 刷新
          --------------------------------------------------
          ["R"] = "refresh",

          --------------------------------------------------
          -- 隐藏文件
          --------------------------------------------------
          ["H"] = "toggle_hidden",

          --------------------------------------------------
          -- 搜索过滤
          --------------------------------------------------
          ["/"] = "fuzzy_finder",

          ["<esc>"] = "cancel",
        },
      },
    },

    window = {
      width = 35,

      mappings = {
        ["<space>"] = "none",
      },
    },
  },
}
