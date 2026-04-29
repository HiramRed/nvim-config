-- color
vim.api.nvim_set_hl(0, 'NormalFloat', { ctermbg = 'red' })

-- Python provider settings
vim.g.python3_host_prog = '/usr/bin/python3'
vim.g.python_host_prog = '/usr/bin/python'
vim.cmd('set pyxversion=3')

-- nvim init
vim.opt.runtimepath:append(vim.fn.expand('~/.vim'))
vim.opt.runtimepath:append('/Applications/MacVim.app/Contents/Resources/vim/runtime')
vim.opt.packpath = vim.o.runtimepath

-- set insert mode cursor block
vim.o.guicursor = 'n-v-c-sm-i:block,ve:ver25,r-cr-o:hor20'

vim.g.coc_enable = false

-- environment
vim.g.vim_json_conceal = 0
vim.g.vim_markdown_conceal = 0

-- shada
vim.cmd('rsh! ~/.my.shada')
vim.opt.shada = vim.o.shada .. ',:10000'

-- source vimrc
vim.cmd('source ~/.vimrc')

-- lazy.nvim
require("config.lazy")

-- coc -----------------
if vim.g.coc_enable then
  vim.o.statusline = '%{coc#status()}%{get(b:,\'coc_current_function\',\'\')}'

  -- Highlight the symbol and its references when holding the cursor.
  vim.api.nvim_create_autocmd('CursorHold', {
    callback = function()
      vim.fn.CocActionAsync('highlight')
    end
  })

  vim.cmd('source ~/.config/nvim/cocmap.vim')
end

-- source filetype
-- vim.cmd('source ~/.config/nvim/autoload/filetype.vim')

-- colorscheme
-- vim.cmd('colorscheme monokai')

-- syntax
vim.cmd('syntax on')

-- vscode neovim
if vim.g.vscode then
  dofile(vim.fn.expand('~/.config/nvim/lua/code.lua'))
end
