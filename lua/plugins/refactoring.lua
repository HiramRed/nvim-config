return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "lewis6991/async.nvim",
    },
    lazy = false,
    config = function(_, opts)
      -- keymaps
      vim.keymap.set({ "n", "x" }, "<leader>rs", function()
        -- this keymap doesn't select any textobject by default, so you may need to provide one each time you use it.
        require("refactoring").select_refactor()
      end, { desc = "Select refactor" })
    end,
  },
}
