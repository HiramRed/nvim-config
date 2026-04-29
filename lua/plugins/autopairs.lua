-- Autopairs Configuration
return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    enabled = false,
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup({
        check_ts = true,
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
          vue = { "template_string" },
        },
        disable_filetype = { "TelescopePrompt" },
      })

      -- Integrate with cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
}
