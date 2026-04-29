return {
  -- ts_context_commentstring for context-aware comments (Vue, etc.)
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
  },
  -- comment
  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      -- need tree-sitter-vue support
      -- npm install -g tree-sitter-vue tree-sitter
      require('Comment').setup({

        padding = true,
        sticky = true,
        toggler = {
          line = '<leader>cc',
          block = '<leader>C',
        },
        opleader = {
          line = '<leader>c',
          block = '<leader>C',
        },
        mappings = {
          basic = true,
          extra = false,
        },
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    })
    end,
  },
}
