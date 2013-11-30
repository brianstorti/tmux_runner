" Send a text(command) with '\n' at the end
" Examples:
"   TmuxRunner.execute('ls') Execute a `ls` on tmux pane
"   TmuxRunner.execute('ruby' . expand('%:p') Execute current file with ruby
function! TmuxRunner.execute(text)
  let oldbuffer = system(shellescape("tmux show-buffer"))
  call <SID>setTmuxBuffer(a:text)
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

" Command to create a dynamic map to send a command to tmux
" Example:
"   :MapTmuxCmd ,tt mix test
"   " Creates a nnoremap ,tt that executes `mix test` in tmux
command! -nargs=* MapTmuxCmd call <SID>mapTmuxCmd(<q-args>)

function! s:mapTmuxCmd(...)
  let l:args = split(a:000[0], '\ ')
  let l:key = l:args[0]
  let l:cmd = join(l:args[1:], ' ')
  exe "nnoremap " . l:key . " :call TmuxRunner.sendKeys('C-c C-l')<CR>:call TmuxRunner.execute(\"" . l:cmd . "\\n\")<CR>"
endfunction
