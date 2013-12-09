" Send a text(command) with '\n' at the end
" Examples:
"   TmuxRunner.execute('ls') Execute a `ls` on tmux pane
"   TmuxRunner.execute('ruby' . expand('%:p') Execute current file with ruby
function! TmuxRunner.execute(text)
  let oldbuffer = system(shellescape("tmux show-buffer"))
  call <SID>setTmuxBuffer(a:text . "\n")
  call system("tmux paste-buffer -t " . self.target())
  call <SID>setTmuxBuffer(oldbuffer)
endfunction

function! s:setTmuxBuffer(text)
  let buf = substitute(a:text, "'", "\\'", 'g')
  call system("tmux load-buffer -", buf)
endfunction

" Send keys to tmux pane
" Examples:
"   TmuxRunner.sendKeys('C-c') Send Ctrl+C
"   TmuxRunner.sendKeys('Enter') Send Enter
"   TmuxRunner.sendKeys('C-l C-p') Send Ctrl+l and Ctrl+p
function! TmuxRunner.sendKeys(keys)
  for k in split(a:keys, '\s')
    call self.executeKeys(k)
  endfor
endfunction

function! TmuxRunner.executeKeys(keys)
  call system("tmux send-keys -t " . self.target() . " " . a:keys)
endfunction

function! TmuxRunner.target()
  if empty(self.targetPane)
    call self.setTmuxPane()
  end

  return self.targetPane
endfunction

function! TmuxRunner.setTmuxPane()
  let self.tmux = {
        \ 'session': '',
        \ 'window': '',
        \ 'pane': ''
        \ }

  call self.AutocompleteSession()
  call self.AutocompleteWindow()
  call self.AutocompletePane()

  let self.targetPane =  '"' .
        \ self.tmux['session'] . '":' .
        \ self.tmux['window'] . "." .
        \ self.tmux['pane']
endfunction

function! TmuxRunner.AutocompleteSession()
  let l:sessions = split(TmuxSessionNames(), "\n")

  if len(l:sessions) == 1
    let self.tmux['session'] = l:sessions[0]
  else
    let self.tmux['session'] = ''
  endif

  while self.tmux['session'] == ''
    let self.tmux['session'] = input("session name: ", "", "custom,TmuxSessionNames")
  endwhile

  let g:tmux_runner['session'] = self.tmux['session']
endfunction

function! TmuxSessionNames(...)
  return system("tmux list-sessions | sed -e 's/:.*$//'")
endfunction

function! TmuxRunner.AutocompleteWindow()
  let l:windows = split(TmuxWindowNames(), "\n")

  if len(l:windows) == 1
    let self.tmux['window'] = l:windows[0]
  else
    let self.tmux['window'] = ''
  endif

  while self.tmux['window'] == ''
    let self.tmux['window'] = input("window name: ", "", "custom,TmuxWindowNames")
  endwhile
  let self.tmux['window'] = substitute(self.tmux['window'], ":.*$" , '', 'g')

  let g:tmux_runner['window'] = self.tmux['window']
endfunction

function! TmuxWindowNames(...)
  return system('tmux list-windows -t "' . g:tmux_runner['session'] .
        \ '" | grep -e "^\w:" | sed -e "s/\s*([0-9].*//g"')
endfunction

function! TmuxRunner.AutocompletePane()
  let l:panes = split(TmuxPaneNumbers(), "\n")
  if len(panes) == 1
    let self.tmux['pane'] = l:panes[0]
  else
    let self.tmux['pane'] = input("pane number: ", "", "custom,TmuxPaneNumbers")
    if self.tmux['pane'] == ''
      let self.tmux['pane'] = panes[0]
    endif
  endif

  let g:tmux_runner['pane'] = self.tmux['pane']
endfunction

function! TmuxPaneNumbers(...)
  return system('tmux list-panes -t "' . g:tmux_runner['session'] .
        \ '":' . g:tmux_runner['window'] . " | sed -e 's/:.*$//'")
endfunction

" Command to create a dynamic map to send a command to tmux
" Example:
"   :MapTmuxCmd ,tt mix test
"   " Creates a nnoremap ,tt that executes `mix test` in tmux
command! -nargs=* MapTmuxCmd call <SID>mapTmuxCmd(<q-args>)

function! s:mapTmuxCmd(...)
  let l:args = split(a:000[0], '\ ')
  let l:key = l:args[0]
  let l:cmd = join(l:args[1:], ' ')
  exe "nnoremap " . l:key . " :call TmuxRunner.sendKeys('C-c C-l')<CR>:call TmuxRunner.execute(\"" . l:cmd . "\")<CR>"
endfunction
