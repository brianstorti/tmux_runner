if exists('TmuxRunnerData.loaded')
  finish
else
  let g:TmuxRunner = {}
  let g:TmuxRunnerData = {
        \ 'loaded': 1,
        \ 'runners': {},
        \ 'runner': '',
        \ 'tmux': {},
        \ 'lastCommand': ''
        \ }
endif

function! TmuxRunner.setTmuxPane()
  call tmux_selector#set()
endfunction

function! TmuxRunner.setRunner()
  call runner_selector#user_select()
endfunction

function! TmuxRunner.register(runner)
  let g:TmuxRunnerData.runners[a:runner.name] = a:runner
endfunction

function! TmuxRunner.execute(cmd, ...)
  if a:0 > 0
    let keep = a:1
  else
    let keep = 1
  endif

  call tmux_interface#execute(a:cmd, keep)
endfunction
command! -nargs=* Tmux call TmuxRunner.execute('<Args>', 0)

function! TmuxRunner.reExecute(...)
  call tmux_interface#execute(g:TmuxRunnerData.lastCommand, 0)
endfunction

function! TmuxRunner.sendKeys(keys)
  call tmux_interface#sendKeys(a:keys)
endfunction

function! TmuxRunner.run(scope)
  call runner#run(a:scope)
endfunction

" Command to create a dynamic map to send a command to tmux
" The command executed by a dynamic map will not be saved as lastCommand
"
" Example:
"   :MapTmuxCmd ,tt mix test
"   " Creates a nnoremap ,tt that executes `mix test` in tmux
command! -nargs=* MapTmuxCmd call <SID>mapTmuxCmd(<q-args>)
function! s:mapTmuxCmd(...)
  let l:args = split(a:000[0], '\ ')
  let l:key = l:args[0]
  let l:cmd = join(l:args[1:], ' ')
  exe "nnoremap " . l:key . " :call TmuxRunner.sendKeys('C-c C-l') \\| call TmuxRunner.execute(\"" . l:cmd . "\", 0)<CR>"
endfunction
