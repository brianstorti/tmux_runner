function! runner#run(scope)
  if empty(runner_selector#runner())
    echo 'No TmuxRunner runner registred'
    return
  endif

  let thisFile = expand('%:p')

  if a:scope != 'unscoped' && !g:TmuxRunnerData.runner.validate(thisFile)
    echo 'Not a test file'
    return
  endif

  let g:TmuxRunnerData.lastCommand = g:TmuxRunnerData.runner.commandFor(thisFile, a:scope)

  call tmux_interface#sendKeys('C-c C-l')
  call tmux_interface#execute(g:TmuxRunnerData.lastCommand)
endfunction
