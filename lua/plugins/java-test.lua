-- Java Test Runner Plugin Spec
-- Provides VSCode-like test execution capabilities

return {
  "mfussenegger/nvim-jdtls",
  optional = true,
  config = function()
    local test = require("java.test")
    local opts = { noremap = true, silent = true }

    vim.keymap.set("n", "<leader>tt", test.run_test_under_cursor, vim.tbl_extend("force", opts, { desc = "Run test under cursor" }))
    vim.keymap.set("n", "<leader>td", test.debug_test_under_cursor, vim.tbl_extend("force", opts, { desc = "Debug test under cursor" }))
    vim.keymap.set("n", "<leader>tc", test.run_all_tests_in_class, vim.tbl_extend("force", opts, { desc = "Run all tests in class" }))

    -- Additional test-related keybindings
    vim.keymap.set("n", "<leader>ta", function()
      vim.cmd("!mvn test")
    end, vim.tbl_extend("force", opts, { desc = "Run all tests (Maven)" }))

    vim.keymap.set("n", "<leader>tA", function()
      vim.cmd("!./gradlew test")
    end, vim.tbl_extend("force", opts, { desc = "Run all tests (Gradle)" }))
  end,
}
