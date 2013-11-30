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
