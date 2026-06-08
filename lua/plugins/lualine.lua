return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        sections = {
          lualine_c = {
            {
              "filename",
              path = 1, -- 显示相对路径
            },
          },
        },
      })
    end,
  },
}
