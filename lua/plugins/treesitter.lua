return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "MeanderingProgrammer/treesitter-modules.nvim",
    },
    opts = {
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "javascript",
        "typescript",
        "tsx",
        "jsx",
        "vue",
        "html",
        "css",
        "scss",
        "rust",
        "java",
        "markdown",
        "markdown_inline",
      },
      sync_install = false,
      auto_install = true,
    },
  },
  {
    "MeanderingProgrammer/treesitter-modules.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      highlight = {
        enable = true,
        disable = function(ctx)
          local max_filesize = 100 * 1024
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(ctx.buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          -- init_selection = "<cr>",
          -- node_incremental = "<cr>",
          -- scope_incremental = "<s-cr>",
          -- node_decremental = "<bs>",
          init_selection = "<M-o>",      -- Alt+o 开始/扩大
          node_incremental = "<M-o>",
          node_decremental = "<M-i>",    -- Alt+i 缩小
          scope_incremental = "<M-s>",   -- Alt+s 作用域
        },
      },
      indent = {
        enable = true,
      },
    },
  },
}
