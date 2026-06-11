return {
  "sindrets/diffview.nvim",
  -- 依赖插件
  dependencies = {
    "nvim-lua/plenary.nvim", -- 必需：底层 Lua 工具库
    "nvim-tree/nvim-web-devicons", -- 可选：提供文件类型图标，让左侧面板更美观
  },

  -- 懒加载设置：只有在执行这些命令或按下快捷键时才加载插件
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewFileHistory",
    "DiffviewRefresh",
  },

  keys = {
    -- 查看当前工作区/暂存区的变动 (git status & diff)
    { "<leader>gS", "<cmd>DiffviewOpen<cr>", desc = "Git Diff (Status)" },
    -- 关闭 Diffview 面板
    { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
    -- 查看当前文件的历史变动记录
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Git File History (Current)" },
    -- 查看整个分支/项目的历史变动记录
    { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Git File History (Project)" },
  },

  config = function()
    require("diffview").setup({
      -- Diffview 命令的默认参数
      default_args = {
        DiffviewOpen = {},
        DiffviewFileHistory = {},
      },

      -- 增强差异高亮（让修改的字符更醒目，而不仅仅是整行变色）
      enhanced_diff_hl = true,

      -- 文件面板配置（左侧面板）
      file_panel = {
        listing_style = "tree", -- "tree" 或 "list"。推荐 "tree"，能看清目录结构
        tree_options = {
          flatten_dirs = true, -- 如果目录下只有一个子目录，是否合并显示
          folder_statuses = "only_folded", -- 只在折叠的目录上显示 git 状态
        },
        win_config = {
          position = "left", -- 面板位置："left", "right", "top", "bottom"
          width = 40, -- 面板宽度
        },
      },

      -- 文件历史面板配置
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              diff_merges = "combined", -- 查看单个文件时，合并提交如何展示
            },
            multi_file = {
              diff_merges = "first-parent", -- 查看多文件时，合并提交如何展示
            },
          },
        },
        win_config = {
          position = "bottom", -- 历史面板通常放在底部比较舒服
          height = 16,
        },
      },

      -- 默认差异布局模式
      -- "diff1_plain" | "diff2_horizontal" | "diff2_vertical" | "diff3_horizontal" |
      -- "diff3_vertical" | "diff3_mixed" | "diff4_mixed"
      view = {
        default = {
          layout = "diff2_horizontal", -- 最经典的左右对比
        },
        merge_tool = {
          layout = "diff3_horizontal", -- 解决合并冲突时，4窗口混合布局 (OURS, BASE, THEIRS, 结果)
        },
        file_history = {
          layout = "diff2_horizontal", -- 查看历史时，左右对比
        },
      },

      -- 键位映射（只在 Diffview 面板内生效）
      keymaps = {
        disable_defaults = false, -- 设为 true 可禁用默认快捷键
        view = {
          -- 在差异视图中，可以使用 <tab> 切换文件面板的展开/折叠
          -- ["<tab>"] = require("diffview.actions").select_next_entry,
          -- ["<s-tab>"] = require("diffview.actions").select_prev_entry,
        },
        merge_tool = {
          ["co"] = require("diffview.actions").conflict_choose("ours"),
          ["ct"] = require("diffview.actions").conflict_choose("theirs"),
          ["ca"] = require("diffview.actions").conflict_choose("all"),
        },
        file_panel = {
          ["j"] = require("diffview.actions").next_entry, -- 下一个文件
          ["k"] = require("diffview.actions").prev_entry, -- 上一个文件
          ["<cr>"] = require("diffview.actions").select_entry, -- 打开文件差异
          ["l"] = require("diffview.actions").select_entry, -- 类似 VSCode，按 l 打开
          ["-"] = require("diffview.actions").toggle_stage_entry, -- 暂存/取消暂存
          ["S"] = require("diffview.actions").stage_all, -- 全部暂存
          ["U"] = require("diffview.actions").unstage_all, -- 全部取消暂存
        },
      },
    })
  end,
}
