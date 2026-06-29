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

vim.opt.winminwidth = 20
vim.opt.winheight = 20
vim.opt.winminheight = 10

vim.opt.list = true -- 开启不可见字符显示

-- 设置显示规则
vim.opt.listchars = {
  eol = ' ',       -- 显示真实的换行符
  trail = '•',     -- 识别并显示行尾多余的空格
  space = ' ',     -- 正常的单词间空格不显示（保持干净），若想显示可改为 '·'
  tab = '→ ',      -- 显示 TAB 符
  nbsp = '⦸',      -- 显示不换行空格
}

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

-- utils
require("utils")

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

-- 新无名buffer自动变为无痕buffer
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("AutoScratch", { clear = true }),
  callback = function()
    local buf = vim.api.nvim_get_current_buf()

    -- 判断条件：
    -- 1. 没有文件名 (对应 :enew/:vnew 产生的空buffer)
    -- 2. buftype 为空 (确保不是插件创建的特殊 buffer，如 floating window / prompt)
    -- 3. 没有被修改过 (刚创建的纯洁状态)
    if vim.api.nvim_buf_get_name(buf) == "" and vim.bo[buf].buftype == "" and not vim.bo[buf].modified then
      vim.bo[buf].buflisted = false  -- 不进入 :ls 列表
      vim.bo[buf].buftype = "nofile" -- 不可保存
      vim.bo[buf].bufhidden = "hide" -- 隐藏而不删除
      vim.bo[buf].swapfile = false   -- 无 swap 文件
    end
  end,
})

