function! s:Validator(file)
  return (match(a:file, '_feature.rb') != -1)
        \ || (match(a:file, '_spec.rb') != -1)
endfunction

function! s:CommandBuilder(file, scope)
  let rspec_command = <SID>disableAutoSegClientExtensions(a:file)

  if a:scope != "unscoped"
    let rspec_command .= ' '.matchstr(a:file, 'spec.*')

    if a:scope == 'current'
      let rspec_command .= ':'.line('.')
    endif
  endif

  return rspec_command
endfunction

function! s:disableAutoSegClientExtensions(file)
  let rspec_command = ''

  if (match(a:file, '\cautoseg') != -1) && (match(a:file, '\ccliente') == -1)
    let rspec_command .= 'CLIENT_EXTENSIONS_DISABLED=true '
  endif

  let rspec_command .= 'rspec '

  return rspec_command
endfunction

let s:rspec = {
      \ 'name': 'rspec',
      \ 'validate': function('s:Validator'),
      \ 'commandFor': function('s:CommandBuilder')
      \ }

call TmuxRunner.register(s:rspec)
