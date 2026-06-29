vim.keymap.set("n", "<leader>y", function()
  local filename = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())

  if filename == "" then
    vim.notify("No file name", vim.log.levels.WARN)
    return
  end

  local basename = vim.fn.fnamemodify(filename, ":t")
  local relative = vim.fn.fnamemodify(filename, ":.")
  local absolute = vim.fn.fnamemodify(filename, ":p")

  local items = {
    { label = "relative path: " .. relative,  value = relative },
    { label = "absolute path: " .. absolute,  value = absolute },
    { label = "basename:      " .. basename,  value = basename },
  }

  vim.ui.select(items, {
    prompt = "Copy path:",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if choice then
      vim.fn.setreg("+", choice.value)
      vim.notify("Copied: " .. choice.value, vim.log.levels.INFO)
    end
  end)
end, { desc = "Copy file path (basename/relative/absolute)" })
