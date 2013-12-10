function! TmuxRunner.register(runner)
  let self.runners[a:runner.name] = a:runner
endfunction

function! TmuxRunner.run(scope)
  if len(self.runners) == 0
    echo 'No TmuxRunner runner registred'
    return
  endif

  if empty(self.runner)
    call self.selectRunner()
  endif

  let thisFile = expand('%:p')

  if a:scope != 'unscoped' && !self.runner.validate(thisFile)
    echo 'Not a test file'
    return
  endif

  let self.lastCommand = self.runner.commandFor(thisFile, a:scope)

  call self.sendKeys('C-c C-l')
  call self.execute(self.lastCommand)
endfunction

function! TmuxRunner.selectRunner()
  if len(self.runners) == 1
    let self.runner = self.runners[keys(self.runners)[0]]
    return
  endif

  let g:TmuxRunner_runners = self.runners
  let selected = input('Choose a runner: ', '', 'customlist,RunnersCompletion')
  let self.runner = self.runners[selected]
endfunction
command! SelectTmuxRunner call TmuxRunner.selectRunner()

function! RunnersCompletion(A, L, P)
  let runners = copy(keys(g:TmuxRunner_runners))
  return filter(runners, 'v:val =~ "' . a:A . '"')
endfunction
