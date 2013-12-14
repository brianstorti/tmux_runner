function! runner_selector#runner()
  if empty(g:TmuxRunnerData.runner)
    call runner_selector#user_select()
  end

  return g:TmuxRunnerData.runner
endfunction

function! runner_selector#autoselect(runner)
  call <SID>load_runner(a:runner)
  if !empty(g:TmuxRunnerData.runner)
    let g:TmuxRunnerData.runner = ''
  else
    let g:TmuxRunnerData.runner = g:TmuxRunnerData.runners[a:runner]
  endif
endfunction

function! s:load_runner(runner)
  if has_key(g:TmuxRunnerData.runners, a:runner)
    return
  endif

  let runner_path = printf("ftplugin/**/%s.vim", a:runner)
  let runner_file = globpath(&rtp, runner_path)

  echom runner_file
  if !empty(runner_file)
    execute "source " . runner_file
    echo a:runner . " runner loaded"
  endif
endfunction

function! runner_selector#user_select()
  if len(g:TmuxRunnerData.runners) == 1
    return runner_selector#set(keys(g:TmuxRunnerData.runners)[0])
  endif

  let selected = input('Choose a runner: ', '', 'customlist,runner_selector#autocomplete')
  return runner_selector#set(selected)
endfunction

function! runner_selector#autocomplete(...)
  let runners = copy(keys(g:TmuxRunnerData.runners))

  return filter(runners, 'v:val =~ "' . a:1 . '"')
endfunction

function! runner_selector#set(runner)
  let g:TmuxRunnerData.runner = g:TmuxRunnerData.runners[a:runner]
endfunction
