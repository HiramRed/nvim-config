return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    -- Optional dependencies
    -- dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    keys = {
      {
        "<leader>xd",
        function()
          require("oil").open()
        end,
        desc = "Oil",
      },
    },
    opts = {
      default_file_explorer = true,

      delete_to_trash = false,

      -- skip_confirm_for_simple_edits = true,

      view_options = {
        show_hidden = true,
      },

      -- float = {
      --   padding = 2,
      --   max_width = 120,
      --   max_height = 40,
      --   border = "rounded",
      -- },

      keymaps = {
        ["<CR>"] = "actions.select",

        ["-"] = "actions.parent",

        ["<C-v>"] = "actions.select_vsplit",

        ["<C-s>"] = "actions.select_split",

        ["g."] = "actions.toggle_hidden",

        ["R"] = "actions.refresh",

        ["<leader>cd"] = "actions.cd",
      },
    },
  }
}
