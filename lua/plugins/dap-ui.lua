return {
  -- nvim-dap-ui: Debug UI
  {
    "rcarriga/nvim-dap-ui",
    ft = "java",
    enabled = false,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-dap",
    },
    config = function()
      local dapui = require("dapui")

      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.5 },
              { id = "breakpoints", size = 0.5 },
              -- { id = "stacks", size = 0.25 },
              -- { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              -- { id = "repl", size = 0.2 },
              { id = "console", size = 1 },
            },
            size = 15,
            position = "bottom",
          },
          {
            elements = {
              { id = "repl", size = 1 },
            },
            size = 1,
            position = "top",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "single",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil,
          max_value_lines = 100,
        },
      })

      -- Debug UI controls
      vim.keymap.set("n", "<leader>ds", function()
        dapui.toggle()
      end, { desc = "Toggle Debug UI" })

      vim.keymap.set({ "n", "v" }, "<leader>da", function()
        dapui.eval(nil, {
          enter = true,
        })
      end)

      vim.keymap.set("n", "<leader>dv", function()
        require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes)
      end)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "dap-float",
          "dapui_scopes",
          "dapui_breakpoints",
          "dapui_stacks",
          "dapui_watches",
        },
        callback = function(args)
          vim.keymap.set("n", "q", "<cmd>close<cr>", {
            buffer = args.buf,
            silent = true,
          })
        end,
      })

      -- Auto open/close dapui
      local dap = require("dap")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        -- dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        -- dapui.close()
      end
    end,
  },

  -- nvim-nio: Required for dap-ui
  {
    "nvim-neotest/nvim-nio",
    ft = "java",
  },
}
