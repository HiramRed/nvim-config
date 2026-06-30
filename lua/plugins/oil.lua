return {
  {
    "albenisolmos/telescope-oil.nvim",
    config = function()
      require("telescope").load_extension("oil")
      vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oil<CR>", { desc = "Fuzzy find directory (Oil)" })
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "stevearc/oil.nvim",
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

      delete_to_trash = true,

      -- skip_confirm_for_simple_edits = true,

      view_options = {
        show_hidden = true,
      },

      columns = {
        "icon", -- 文件类型图标（通常默认就有）
        "permissions", -- Unix 权限，例如 rwxr-xr-x
        "size", -- 文件大小（人类可读格式，如 1.2K, 3.4M）
        -- "mtime", -- 修改时间
        -- "ctime",     -- 状态变更时间
        -- "atime",     -- 最后访问时间
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

        ["g?"] = { "actions.show_help", mode = "n" },
      },
    },
  },
}
