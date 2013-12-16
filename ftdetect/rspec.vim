au VimEnter,BufRead,BufNewFile *_spec.rb,*_feature.rb call <SID>TmuxRunner_Set()
au VimEnter *
      \ if filereadable('spec/spec_helper.rb') |
      \   call <SID>TmuxRunner_Set() |
      \ endif

function! s:TmuxRunner_Set()
  call runner_selector#autoselect('rspec')
endfunction
