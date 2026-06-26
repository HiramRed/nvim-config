return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      render_modes = { "n", "c" },
      anti_conceal = {
        enabled = true,
        ignore = {
          code_background = true,
          sign = true,
        },
      },
      file_types = { "markdown" },
      -- heading = {
      --   -- Nerd Font 图标依赖特殊字体，改成纯文本
      --   icons = { '# ', '## ', '### ', '#### ', '##### ', '###### ' },
      -- },
    },
  },
}
