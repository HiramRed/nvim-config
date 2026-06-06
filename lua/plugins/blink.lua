return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
    },
    version = "*",
    opts = {
      keymap = {
        preset = "enter",
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<Tab>"] = { "accept", "fallback" },
      },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      signature = { enabled = true },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          snippets = {
            opts = {
              friendly_snippets = true,
            },
          },
        },
      },
      completion = {
        menu = {
          draw = {
            padding = 1,
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
      },
    },
    opts_extend = { "sources.default" },
    config = function(_, opts)
      require("blink.cmp").setup(opts)

      -- 加载自定义 snippets
      local luasnip = require("luasnip")
      luasnip.config.setup({})

      -- 加载 lua/snippets/ 目录下的 snippets
      require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })
    end,
  },
}
