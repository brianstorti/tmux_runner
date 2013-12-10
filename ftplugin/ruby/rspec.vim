let s:rspec = { 'name': 'rspec' }

function! s:rspec.validate(file)
  return (match(a:file, '_feature.rb') != -1)
        \ || (match(a:file, '_spec.rb') != -1)
endfunction

function! s:rspec.commandFor(file, scope)
  let rspec_command = 'rspec'

  if a:scope != 'unscoped'
    let rspec_command .= ' '.matchstr(a:file, 'spec.*')

    if a:scope == 'current'
      let rspec_command .= ':'.line('.')
    endif
  endif

  return rspec_command
endfunction

call TmuxRunner.register(s:rspec)
