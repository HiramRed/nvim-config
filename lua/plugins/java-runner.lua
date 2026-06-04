-- Java Application Runner Plugin Spec
-- Provides VSCode-like run/debug functionality

return {
  "mfussenegger/nvim-jdtls",
  optional = true,
  config = function()
    local runner = require("java.runner")
    local opts = { noremap = true, silent = true }

    vim.keymap.set("n", "<leader>rm", runner.run_main, vim.tbl_extend("force", opts, { desc = "Run main method" }))
    vim.keymap.set("n", "<leader>dm", runner.debug_main, vim.tbl_extend("force", opts, { desc = "Debug main method" }))
    vim.keymap.set("n", "<leader>ra", runner.run_with_args, vim.tbl_extend("force", opts, { desc = "Run with arguments" }))
    vim.keymap.set("n", "<leader>rc", runner.compile_project, vim.tbl_extend("force", opts, { desc = "Compile project" }))
    vim.keymap.set("n", "<leader>rb", runner.build_project, vim.tbl_extend("force", opts, { desc = "Build project" }))
  end,
}
