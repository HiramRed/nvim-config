local vscode = require('vscode')

-- key mapping

vim.keymap.set({ "n" }, "<leader>ff", function()
  vscode.action('eslint.executeAutofix')
end)

vim.keymap.set({ "n" }, "g;", function()
  vscode.action('workbench.action.navigateBackInEditLocations')
end)

vim.keymap.set({ "n" }, "g,", function()
  vscode.action('workbench.action.navigateForwardInEditLocations')
end)

vim.keymap.set({ "n" }, "<leader>b", function()
  vscode.action('editor.debug.action.toggleBreakpoint')
end)

vim.keymap.set({ "n" }, "<leader>i", function()
  vscode.action('editor.action.goToImplementation')
end)

vim.keymap.set({ "n" }, "<leader>sa", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("$[ V%", true, false, true), "n", false)
end, { desc = "Select all content" })

vim.keymap.set({ "n" }, "<leader>sd", function()
  vscode.action('workbench.action.debug.selectandstart')
end)

vim.keymap.set({ "n" }, "]m", function()
  vscode.action('gotoNextPreviousMember.nextMember')
end)

vim.keymap.set({ "n" }, "[m", function()
  vscode.action('gotoNextPreviousMember.previousMember')
end)

vim.keymap.set({ "n" }, "zO", function()
  vscode.action('editor.unfoldAll')
end, { desc = "Unfold all" })

vim.keymap.set({ "n" }, "zC", function()
  vscode.action('editor.foldAll')
end, { desc = "Fold all" })

vim.keymap.set({ "n" }, "<leader>rn", function()
  vscode.action('editor.action.rename')
end)

vim.keymap.set({ "n" }, "'", "`")
vim.keymap.set({ "n", "o", "x" }, "<leader>z", function()
  vscode.action('git.revertSelectedRanges')
end)

vim.keymap.set({ "n" }, "[c", function()
  vscode.action('workbench.action.editor.previousChange')
end)

vim.keymap.set({ "n" }, "]c", function()
  vscode.action('workbench.action.editor.nextChange')
end)

vim.keymap.set({ "n" }, "]g", function()
  vscode.action('editor.action.marker.next')
end)

vim.keymap.set({ "n" }, "[g", function()
  vscode.action('editor.action.marker.prev')
end)

vim.keymap.set({ "n" }, "gy", function()
  vscode.action('editor.action.peekDefinition')
end)

vim.keymap.set({ "n" }, "<leader>ss", function()
  vscode.action('workbench.files.action.showActiveFileInExplorer')
end)

vim.keymap.set({ "n" }, "<leader>e", function()
  vscode.action('workbench.files.action.showActiveFileInExplorer')
end)

vim.keymap.set({ "n", "v" }, "<leader>sr", function()
  vscode.action('surround.with')
end)

vim.keymap.set({ "n" }, "<leader><tab>", function()
  vscode.action('workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup')
end)

vim.keymap.set({ "n" }, "<c-6>", function()
  vscode.action('workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup')
end)
