-- Java debug configuration
local function setup_java_debug_configuration()
  local dap = require("dap")

  dap.configurations.java = {
    {
      type = "java",
      request = "launch",
      name = "Launch Current File",
      mainClass = function()
        local path = vim.fn.expand("%:p")
        local classname = vim.fn.fnamemodify(path, ":t:r")
        return classname
      end,
      projectName = function()
        return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      end,
      cwd = vim.fn.getcwd(),
      console = "integratedTerminal",
      stopOnEntry = false,
      args = "",
    },
    {
      type = "java",
      request = "attach",
      name = "Attach to Remote Debug",
      hostName = "127.0.0.1",
      port = 5005,
    },
  }

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
      vim.defer_fn(function()
        if dap.configurations.java then
          for _, config in ipairs(dap.configurations.java) do
            config.console = "integratedTerminal"
          end
        end
      end, 1000)
    end,
  })
end

-- Javascript/Typescript debug configuration
local function setup_typescript_debug_configuration()
  local dap = require("dap")
  dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "js-debug-adapter",
      args = {
        "${port}",
      },
    },
  }

  dap.configurations.javascript = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch File",
      console = "integratedTerminal",

      program = "${file}",
      cwd = "${workspaceFolder}",
    },
  }

  dap.configurations.typescript = dap.configurations.javascript
end

return {
  -- nvim-dap: Debug Adapter Protocol
  {
    "mfussenegger/nvim-dap",
    ft = "java",
    config = function()
      local dap = require("dap")

      -- 配置终端行为
      dap.defaults.fallback.terminal_win_cmd = function()
        -- 在新垂直分割窗口中打开终端
        return "botright 15new term://zsh"
      end

      vim.fn.sign_define("DapBreakpoint", {
        text = "",
        texthl = "DiagnosticSignError",
      })

      vim.fn.sign_define("DapStopped", {
        text = "",
        texthl = "DiagnosticSignWarn",
      })

      -- Key mappings for debugging
      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step Out" })
      -- vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run Last" })
      vim.keymap.set("n", "<leader>dx", dap.terminate, { desc = "Terminate" })

      setup_java_debug_configuration()
      setup_typescript_debug_configuration()
    end,
  },
}
