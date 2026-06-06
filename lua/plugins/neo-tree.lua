return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  enabled = false,
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
          -- 基础移动
          --------------------------------------------------
          ["j"] = "next",
          ["k"] = "prev",

          --------------------------------------------------
          -- NERDTree风格
          --------------------------------------------------
          ["o"] = "open",

          -- ["p"] = "navigate_up",

          --------------------------------------------------
          -- 同级跳转
          --------------------------------------------------
          ["<C-j>"] = "next_sibling",
          ["<C-k>"] = "prev_sibling",

          --------------------------------------------------
          -- 第一个/最后一个节点
          --------------------------------------------------
          ["K"] = "first_sibling",
          ["J"] = "last_sibling",

          --------------------------------------------------
          -- 展开折叠
          --------------------------------------------------
          ["l"] = "open",
          ["h"] = "close_node",

          --------------------------------------------------
          -- 文件操作
          --------------------------------------------------
          ["a"] = {
            "add",
            config = {
              show_path = "relative",
            },
          },

          ["A"] = "add_directory",

          ["r"] = "rename",

          ["d"] = "delete",

          ["y"] = "copy_to_clipboard",

          ["x"] = "cut_to_clipboard",

          ["P"] = "paste_from_clipboard",

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

          --------------------------------------------------
          -- 定位当前文件
          --------------------------------------------------
          ["gf"] = "show_file_details",

          --------------------------------------------------
          -- 关闭
          --------------------------------------------------
          ["q"] = "close_window",

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
