-- Treesitter Autotag Configuration
return {
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_close_on_slash = false,
          enable_rename = true,
          enable_close_on_tag = true,
        },
        filetypes = {
          "html",
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "svelte",
          "vue",
          "tsx",
          "jsx",
          "rescript",
          "xml",
          "xmli",
          "markdown",
          "glimmer",
          "handlebars",
          "hbs",
        },
      })
    end,
  },
}
