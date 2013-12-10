let s:minitest = { "name": "minitest" }

function! s:minitest.validate(file)
  return (match(a:file, "_test.rb") != -1)
endfunction

function! s:minitest.commandFor(file, scope)
  if a:scope == "unscoped"
    let command = "rake test"
  else
    let command = "ruby -Itest ".a:file

    if a:scope == "current"
      let command .= " -n /" . s:GetCurrentTest() . "/"
    endif
  endif

  return command
endfunction

function! s:GetCurrentTest()
  let winview = winsaveview()

  let current_test = search("def\ test_", "b")

  if current_test != 0
    let test_name = matchstr(getline(current_test), "test_.*")
  else
    let current_test = search('\(test\s["'']\|it\s["'']\)', "b")

    let test_string = split(getline(current_test), '["'']')[1]
    let test_name = escape(tolower(test_string), "\ ")
  endif

  call winrestview(l:winview)
  return test_name
endfunction

call TmuxRunner.register(s:minitest)
