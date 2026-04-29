-- Gitsigns Configuration
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local gitsigns = require("gitsigns")

      gitsigns.setup({
        signs = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
          interval = 1000,
          follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
          delay = 200,
        },
        current_line_blame_formatter = " <author>: <summary>",
        on_attach = function()
          local gs = package.loaded.gitsigns

          -- Navigation (jump + preview)
          vim.keymap.set("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { desc = "Next git hunk + preview", expr = true })

          vim.keymap.set("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { desc = "Previous git hunk + preview", expr = true })

          -- Actions
          vim.keymap.set({ "n", "v" }, "<leader>z", gs.reset_hunk, { desc = "Revert current line/file hunk" })
          vim.keymap.set("n", "<leader>gb", gs.blame_line, { desc = "Blame current line" })
          vim.keymap.set("n", "<leader>gd", gs.diffthis, { desc = "Diff this" })
          vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
        end,
      })
    end,
  },
}
