function! tmux_interface#execute(text)
  let oldbuffer = system(shellescape("tmux show-buffer"))
  call <SID>setTmuxBuffer(a:text . "\n")
  call system("tmux paste-buffer -t " . tmux#target())
  call <SID>setTmuxBuffer(oldbuffer)
endfunction

function! s:setTmuxBuffer(text)
  let buf = substitute(a:text, "'", "\\'", 'g')
  call system("tmux load-buffer -", buf)
endfunction

function! tmux_interface#sendKeys(keys)
  for k in split(a:keys, '\s')
    call tmux_interface#executeKeys(k)
  endfor
endfunction

function! tmux_interface#executeKeys(keys)
  call system("tmux send-keys -t " . tmux#target() . " " . a:keys)
endfunction
