TmuxRunner
==========

Just another plugin to send commands to tmux, based on tslime.vim

Why TmuxRunner
--------------


Features
--------

* TmuxRunner.setTmuxPane()
* TmuxRunner.execute()
* TmuxRunner.sendKeys()
* TmuxRunner.register()
* TmuxRunner.selectRunner()
* TmuxRunner.run(scope)
* Tmux
* MapTmuxCmd


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
