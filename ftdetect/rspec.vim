au VimEnter,BufRead,BufNewFile *_spec.rb,*_feature.rb call <SID>TmuxRunner_Set('rspec')
au VimEnter *
      \ if filereadable('spec/spec_helper.rb') |
      \   call <SID>TmuxRunner_Set('rspec') |
      \ endif

function! s:TmuxRunner_Set(runner)
  set ft=ruby
  call runner_selector#autoselect(a:runner)
endfunction