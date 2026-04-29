-- Fidget - LSP 进度显示
return {
  "j-hui/fidget.nvim",
  config = function()
    require("fidget").setup({
      progress = {
        display = {
          render_limit = 16,
          done_ttl = 3,
        },
      },
    })
  end,
}
