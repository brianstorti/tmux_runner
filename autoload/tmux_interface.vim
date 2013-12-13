function! tmux_interface#execute(cmd, keep)
  if a:keep
    let g:TmuxRunnerData.lastCommand = a:cmd
  end
  let oldbuffer = system(shellescape("tmux show-buffer"))

  call <SID>setTmuxBuffer(a:cmd . "\n")
  call system("tmux paste-buffer -t " . tmux_selector#target())
  call <SID>setTmuxBuffer(oldbuffer)
endfunction

function! s:setTmuxBuffer(text)
  let buf = substitute(a:text, "'", "\\'", 'g')
  call system("tmux load-buffer -", buf)
endfunction

function! tmux_interface#sendKeys(keys)
  for k in split(a:keys, '\s')
    call <SID>executeKeys(k)
  endfor
endfunction

function! s:executeKeys(keys)
  call system("tmux send-keys -t " . tmux_selector#target() . " " . a:keys)
endfunction
