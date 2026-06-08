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
          lualine_y = {
            function()
              local current = vim.fn.line(".")
              local total = vim.fn.line("$")
              -- local percent = math.floor((current * 100) / total)
              return string.format("%d/%d", current, total)
            end,
          },
        },
      })
    end,
  },
}
