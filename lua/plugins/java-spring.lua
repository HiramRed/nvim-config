-- Spring Boot Support Plugin Spec
-- Provides Spring Boot specific functionality

return {
  "mfussenegger/nvim-jdtls",
  optional = true,
  config = function()
    local spring = require("java.spring")
    local opts = { noremap = true, silent = true }

    vim.keymap.set("n", "<leader>sr", spring.run_spring_boot, vim.tbl_extend("force", opts, { desc = "Run Spring Boot app" }))
    vim.keymap.set("n", "<leader>sd", spring.debug_spring_boot, vim.tbl_extend("force", opts, { desc = "Debug Spring Boot app" }))
    vim.keymap.set(
      "n",
      "<leader>sg",
      spring.generate_spring_boot_project,
      vim.tbl_extend("force", opts, { desc = "Generate Spring Boot project" })
    )
  end,
}
