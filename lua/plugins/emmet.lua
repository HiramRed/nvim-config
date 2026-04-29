return {
  {
    "mattn/emmet-vim",
    ft = { "html", "vue", "htmldjango" },
    config = function()
      vim.g.user_emmet_leader_key = "<C-y>"
      vim.g.user_emmet_settings = {
        global = {
          languages = {
            vue = "html",
            html = "html",
            htmldjango = "html",
          },
        },
      }
    end,
  },
}
