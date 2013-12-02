if exists('TmuxRunner.loaded')
  finish
else
  let TmuxRunner = {
        \ 'loaded': 1,
        \ 'tmux': {},
        \ 'targetPane': '',
        \ 'lastCommand': '',
        \ 'runners': {},
        \ 'runner': ''
        \ }
  let g:tmux_runner = {}
endif

command! -nargs=* Tmux call TmuxRunner.execute('<Args>')
cabbrev T Tmux
