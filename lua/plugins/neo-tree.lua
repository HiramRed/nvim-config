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

    sources = {
      "filesystem",
      "git_status",
    },

    source_selector = {
      winbar = true,
      statusline = true,
    },

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

      commands = {
        -- 自定义一个 trash 命令
        trash = function(state)
          local inputs = require("neo-tree.ui.inputs")
          local node = state.tree:get_node()
          local path = node.path

          -- 弹出确认提示
          inputs.confirm("Move to trash: " .. node.name .. "?", function(confirmed)
            if not confirmed then
              return
            end

            -- 使用 jobstart 异步调用 macOS 的 trash 命令
            -- 注意：直接传 path 即可，vim.fn.jobstart 会正确处理带有空格的路径
            vim.fn.jobstart({ "trash", path }, {
              on_exit = function()
                -- 删除完成后刷新 neo-tree 面板
                require("neo-tree.sources.manager").refresh(state.name)
              end,
            })
          end)
        end,

        -- 复写默认的 delete 命令，让它指向我们上面定义的 trash
        delete = function(state)
          state.commands.trash(state)
        end,
      },

      window = {
        mappings = {
          ["d"] = "delete",
          -- ["u"] = "undo",
          -- ["U"] = "restore_from_trash",
          -- ["<Tab>"] = "select",
          -- ["<C-;>"] = "clear_selection",
          ["/"] = "",
        },
        fuzzy_finder_mappings = {
          ["<S-CR>"] = "close_keep_filter",
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
