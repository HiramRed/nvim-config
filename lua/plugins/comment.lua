return {
  -- ts_context_commentstring for context-aware comments (Vue, etc.)
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = {
      enable_autocmd = true,
    },
  },
  -- comment
  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      local function get_vue_commentstring()
        local line = vim.api.nvim_get_current_line()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local lnum = cursor[1] - 1
        local col = cursor[2]

        -- Get all lines up to cursor
        local lines = vim.api.nvim_buf_get_lines(0, 0, lnum, false)
        local content = table.concat(lines, "\n")

        -- Check if in <script> tag
        if content:match("<script") and not content:match("</script>") then
          return "// %s"
        end

        -- Check if in <style> tag
        if content:match("<style") and not content:match("</style>") then
          return "/* %s */"
        end

        -- Default to HTML comment for <template>
        return "<!-- %s -->"
      end
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
        ---Function to call before (un)comment
        pre_hook = function(ctx)
          local ft = vim.bo.filetype
          if ft == "vue" then
            return get_vue_commentstring()
          end
        end,
    })
    end,
  },
}
