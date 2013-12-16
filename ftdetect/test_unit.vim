au VimEnter,BufRead,BufNewFile *_test.rb call <SID>TmuxRunner_Set()
au VimEnter *
      \ if filereadable('test/test_helper.rb') |
      \   call <SID>TmuxRunner_Set() |
      \ endif

function! s:TmuxRunner_Set(runner)
  call runner_selector#autoselect('test_unit')
endfunction
