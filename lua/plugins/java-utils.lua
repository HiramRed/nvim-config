-- Java Development Utilities Plugin Spec
-- Provides utility commands and setup for Java development

return {
  "mfussenegger/nvim-jdtls",
  optional = true,
  config = function()
    -- Create workspace directory
    local workspace_base = vim.fn.stdpath("data") .. "/jdtls/workspaces"
    if vim.fn.isdirectory(workspace_base) == 0 then
      vim.fn.mkdir(workspace_base, "p")
    end

    -- Setup autocommands for Java files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        -- Initialize Java-specific settings
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.expandtab = true
      end,
    })

    -- Setup commands
    vim.api.nvim_create_user_command("JavaRun", function()
      require("java.runner").run_main()
    end, { desc = "Run Java main method" })

    vim.api.nvim_create_user_command("JavaDebug", function()
      require("java.runner").debug_main()
    end, { desc = "Debug Java main method" })

    vim.api.nvim_create_user_command("JavaTest", function()
      require("java.test").run_test_under_cursor()
    end, { desc = "Run Java test under cursor" })

    vim.api.nvim_create_user_command("JavaTestDebug", function()
      require("java.test").debug_test_under_cursor()
    end, { desc = "Debug Java test under cursor" })

    vim.api.nvim_create_user_command("JavaClean", function()
      local workspace_dir = vim.fn.stdpath("data") .. "/jdtls/workspaces"
      vim.notify("Cleaning JDTLS workspaces: " .. workspace_dir, vim.log.levels.INFO)
      vim.fn.delete(workspace_dir, "rf")
      vim.fn.mkdir(workspace_dir, "p")
      vim.notify("JDTLS workspaces cleaned", vim.log.levels.INFO)
    end, { desc = "Clean JDTLS workspace cache" })
  end,
}
