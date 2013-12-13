au VimEnter,BufRead,BufNewFile *_test.rb call <SID>TmuxRunner_Set('test_unit')
au VimEnter *
      \ if filereadable('test/test_helper.rb') |
      \   call <SID>TmuxRunner_Set('test_unit') |
      \ endif

function! s:TmuxRunner_Set(runner)
  if empty(bufname('.'))
    set ft=ruby
  endif
  call runner_selector#autoselect(a:runner)
endfunction
