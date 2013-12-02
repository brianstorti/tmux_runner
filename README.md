TmuxRunner
==========

Just another plugin to send commands to tmux, based on tslime.vim

Why TmuxRunner
--------------


Features
--------

* TmuxRunner.setTmuxPane()

  (Re)Selects tmux pane target to send commands and keys.

  !(TmuxRunner.setTmuxPane)[/images/setTmuxPane.gif]

* TmuxRunner.execute(text)

  Executes a text in tmux pane. This command automatically executes
  the text.

  !gif!

* TmuxRunner.sendKeys(keys)

  Sends keys to tmux pane, you can send more than one combination of
  keys splitted by space.

  !gif!

* TmuxRunner.register(runner)

  Registers a Runner

* TmuxRunner.selectRunner()

  (Re)Selects which runner will be used.

* TmuxRunner.run(scope)

  Runs selected runner with given scope.

  !gif!

* :Tmux

  Easy way to send a text to tmux pane

  !gif!

* :MapTmuxCmd

  Creates a map for a command in the current session.


Suggested Setup
---------------

        " Kill current process
        noremap <leader>tc :call TmuxRunner.sendKeys('C-c')<CR>

        " Kill current process and clear screen
        noremap <leader>tl :call TmuxRunner.sendKeys('C-c C-l')<CR>

        " Kill current process, clear screen and repeat last command
        noremap <leader>tp :call TmuxRunner.sendKeys('C-c C-l C-p Enter')<CR>

        " Reset tmux pane target
        noremap <leader>tr :call TmuxRunner.setTmuxPane()<CR>

        " Reset which runner will be used
        noremap <leader>ct :call TmuxRunner.selectRunner()<CR>

        " Run unscoped runner
        noremap <leader>rt :call TmuxRunner.run('unscoped')<CR>

        " Run runner with file scope
        noremap <leader>rf :call TmuxRunner.run('file')<CR>

        " Run runner with current scope
        noremap <leader>rl :call TmuxRunner.run('current')<CR>

        " Kill current process, clear screen and repeat last runner command
        noremap <leader>rr :call TmuxRunner.sendKeys('C-c C-l')<CR>
              \ :call TmuxRunner.execute(TmuxRunner.lastCommand)<CR>
