function! tmux_selector#target()
  if empty(g:TmuxRunnerData.tmux)
    call tmux_selector#set()
  endif

  return g:TmuxRunnerData.target
endfunction

function! tmux_selector#set()
  let g:TmuxRunnerData.tmux = {
        \ 'session': '',
        \ 'window': '',
        \ 'pane': ''
        \ }

  call s:AutocompleteSession()
  call s:AutocompleteWindow()
  call s:AutocompletePane()

  let g:TmuxRunnerData['target'] = printf('%s:%s.%s',
        \ g:TmuxRunnerData.tmux['session'], g:TmuxRunnerData.tmux['window'], g:TmuxRunnerData.tmux['pane'])
endfunction

function! s:AutocompleteSession()
  let l:sessions = split(TmuxSessionNames(), "\n")

  if len(l:sessions) == 1
    let g:TmuxRunnerData.tmux['session'] = l:sessions[0]
  else
    let g:TmuxRunnerData.tmux['session'] = ''
  endif

  while g:TmuxRunnerData.tmux['session'] == ''
    let g:TmuxRunnerData.tmux['session'] = input("session name: ", "", "custom,TmuxSessionNames")
  endwhile

  let g:TmuxRunnerData['session'] = g:TmuxRunnerData.tmux['session']
endfunction

function! TmuxSessionNames(...)
  return system("tmux list-sessions | sed -e 's/:.*$//'")
endfunction

function! s:AutocompleteWindow()
  let l:windows = split(TmuxWindowNames(), "\n")

  if len(l:windows) == 1
    let g:TmuxRunnerData.tmux['window'] = l:windows[0]
  else
    let g:TmuxRunnerData.tmux['window'] = ''
  endif

  while g:TmuxRunnerData.tmux['window'] == ''
    let g:TmuxRunnerData.tmux['window'] = input("window name: ", "", "custom,TmuxWindowNames")
  endwhile
  let g:TmuxRunnerData.tmux['window'] = substitute(g:TmuxRunnerData.tmux['window'], ":.*$" , '', 'g')

  let g:TmuxRunnerData['window'] = g:TmuxRunnerData.tmux['window']
endfunction

function! TmuxWindowNames(...)
  return system('tmux list-windows -t "' . g:TmuxRunnerData['session'] .
        \ '" | grep -e "^\w:" | sed -e "s/\s*([0-9].*//g"')
endfunction

function! s:AutocompletePane()
  let l:panes = split(TmuxPaneNumbers(), "\n")
  if len(panes) == 1
    let g:TmuxRunnerData.tmux['pane'] = l:panes[0]
  else
    let g:TmuxRunnerData.tmux['pane'] = input("pane number: ", "", "custom,TmuxPaneNumbers")
    if g:TmuxRunnerData.tmux['pane'] == ''
      let g:TmuxRunnerData.tmux['pane'] = panes[0]
    endif
  endif

  let g:TmuxRunnerData['pane'] = g:TmuxRunnerData.tmux['pane']
endfunction

function! TmuxPaneNumbers(...)
  return system('tmux list-panes -t "' . g:TmuxRunnerData['session'] .
        \ '":' . g:TmuxRunnerData['window'] . " | sed -e 's/:.*$//'")
endfunction
