return {
  {
    "igorlfs/nvim-dap-view",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    opts = {
      winbar = {
        show = true,
        -- 将 console 合并进主窗口
        sections = {
          "console",
          "scopes",
          "exceptions",
          "breakpoints",
          "threads",
          "sessions",
          "repl",
        },

        default_section = "console",

        show_keymap_hints = true,

        controls = {
          enabled = true,
          position = "left",

          buttons = {
            "play",
            "step_into",
            "step_over",
            "step_out",
            "run_last",
            "terminate",
            "disconnect",
          },
        },
      },

      hover = {
        border = nil,
      },

      keymaps = {
        hover = {
          quit = { "q", "<C-c>", "<esc>" },
        },
      },

      windows = {
        -- 整个 dap-view 位于底部
        position = "below",

        -- 占编辑区 30%
        size = 0.30,

        terminal = {
          -- console 位于主视图左边
          position = "left",

          -- console 占 dap-view 50%
          size = 0.5,

          hide = {},
        },
      },

      auto_toggle = false,

      follow_tab = true,

      virtual_text = {
        enabled = true,
        position = "inline",

        format = function(variable)
          return " " .. variable.value
        end,
      },
    },

    config = function(_, opts)
      local dap = require("dap")
      local dv = require("dap-view")

      dv.setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "dap-view",
          "dap-view-term",
          "dap-repl",
        },
        callback = function(args)
          vim.keymap.set("n", "q", "<C-w>q", {
            buffer = args.buf,
          })
        end,
      })

      -- -- 可以手动清空命令行输出
      -- vim.api.nvim_create_autocmd("FileType", {
      --   pattern = {
      --     "dap-view-term",
      --   },
      --   callback = function(args)
      --     vim.opt_local.modifiable = true
      --   end,
      -- })

      dap.listeners.before.attach.dap_view = function()
        dv.open()
      end

      dap.listeners.before.launch.dap_view = function()
        dv.open()
      end

      dap.listeners.before.event_terminated.dap_view = function()
        -- dv.close()
      end

      dap.listeners.before.event_exited.dap_view = function()
        -- dv.close()
      end

      vim.keymap.set("n", "<leader>ds", dv.toggle, {
        desc = "Toggle Dap View",
      })

      vim.keymap.set({ "n" }, "<leader>dt", function()
        dv.open()
        dv.jump_to_view("console")
      end, { desc = "Toggle Console" })

      vim.keymap.set({ "n" }, "<leader>db", function()
        dv.open()
        dv.jump_to_view("breakpoints")
      end, { desc = "Toggle Breakpoint" })

      vim.keymap.set({ "n" }, "<leader>dr", function()
        dv.open()
        dv.jump_to_view("repl")
      end, { desc = "Toggle Repl" })

      vim.keymap.set({ "n", "v" }, "<2-LeftMouse>", function()
        if dap.session() then
          dv.hover(nil, true)
        end
      end, { desc = "Toggle Hover" })

      vim.keymap.set({ "n", "v" }, "<leader>da", function()
        dv.hover(nil, true)
      end, { desc = "Toggle Breakpoint" })
    end,
  },
}
