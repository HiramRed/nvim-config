" coc ---------------------

" 上一个/下一个错误
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" 上一个/下一个修改
" nmap [c <Plug>(coc-git-prevchunk)
" nmap ]c <Plug>(coc-git-nextchunk)
autocmd BufEnter * call s:map_diff()

function! s:map_diff()
  if &diff
    map [c [c
    map ]c ]c
  else
    nmap [c <Plug>(coc-git-prevchunk)
    nmap ]c <Plug>(coc-git-nextchunk)
  endif
endfunction

" create text object for git chunks
omap ig <Plug>(coc-git-chunk-inner)
xmap ig <Plug>(coc-git-chunk-inner)
omap ag <Plug>(coc-git-chunk-outer)
xmap ag <Plug>(coc-git-chunk-outer)

" 显示当前修改信息
nnoremap <silent> gz :CocCommand git.chunkInfo<cr>

" 撤销当前修改
nnoremap <silent> <leader>z :CocCommand git.chunkUndo<cr>
vnoremap <silent> <leader>z :CocCommand git.chunkUndo<cr>

" go to definition
nmap <silent> gd <Plug>(coc-definition)
nmap <silent><nowait> <leader>i <Plug>(coc-implementation)

" type definition
nmap <silent> gy <Plug>(coc-type-definition)

" nmap <silent> gi <Plug>(coc-implementation)

nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> <leader>cl :CocList<cr>
nnoremap <silent> <leader>cf :call <SID>smart_coclist('quickfix', '')<cr>
nnoremap <silent> <leader>co :CocList outline<cr>
nnoremap <silent> <leader>F :CocList grep<cr>
nnoremap <silent> <leader>b :CocList mru<cr>

" 选中格式化
" vmap = <Plug>(coc-format-selected)

" 显示文档注释
nnoremap <silent> gK :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" 选中function
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

xmap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ic <Plug>(coc-classobj-i)
omap ac <Plug>(coc-classobj-a)

" nmap <leader>rn <Plug>(coc-rename)
nnoremap <leader>rn :CocCommand document.renameCurrentWord<cr>

" nmap <silent> <C-s> <Plug>(coc-range-select)


" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-y>" : 
      \                "\<TAB>"

" inoremap <silent><expr> <C-n>
"       \ pumvisible() ? "\<C-n>" : "\<Down>"
" 
" inoremap <silent><expr> <C-p>
"       \ pumvisible() ? "\<C-p>" : "\<Up>"

inoremap <silent><expr> <C-n>
      \ coc#pum#visible() ? coc#pum#next(1) : "\<down>"

inoremap <silent><expr> <C-p>
      \ coc#pum#visible() ? coc#pum#prev(1) : "\<up>"

inoremap <silent><expr> <C-f> pumvisible() ? "<C-f>" : "\<Right>"
inoremap <silent> <C-b> <Left>

" inoremap <expr> <cr> pumvisible() ? "\<C-g>u\<CR>" : "\<CR>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nnoremap <silent> K :call ShowDocumentation()<CR>

" Use <c-space> to trigger completion.
inoremap <silent><expr> <C-space> coc#refresh()

xmap <leader>fm  <Plug>(coc-format-selected)
nmap <leader>fm  <Plug>(coc-format-selected)
nmap <leader>ff  <Plug>(coc-fix-current)

nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

command! -nargs=0 Format :call CocActionAsync('format')

xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
xmap <silent> <leader>n  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>n  <Plug>(coc-codeaction-refactor-selected)
