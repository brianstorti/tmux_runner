TmuxRunner
==========

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/kassio/tmux_runner/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

(not)Just another plugin to send commands to tmux, based on [tslime.vim](https://github.com/jgdavey/tslime.vim)

Why TmuxRunner
--------------

The main reason to write a new tmux plugin was to avoid the setup needed to run
each program language test suit. Nowadays I use ruby/rails with rpsec, testunit,
and minitest, and I'm trying to have some fun with Elixir.

Before TmuxRunner I had a setup of keymaps for each test framework I wanted to
run, now I have the same keys combination for every framework, I just
need(sometimes) to select which framework I want to run.

I said that sometimes because the runner can check the current "project"
structure and autoselect the runner accordantly with the current structure, for
example if you open the vim and in the current directory has a
`spec/spec_helper.rb` the TmuxRunner will select the rspec runner for you.

With tmux runner you can send any text/command or key's combination to a tmux
pane, just like tslime and vimux. Moreover you can run your test suit based on 3
scopes:

* `unscoped` - run all you test suit.
* `file` - run the current test file.
* `current` - run the current test(tests if you're in a context)

### The Runner

The runner is a dictionary with 3 keys:

* `name`: Just a string with the runner name, e.g. 'rspec'
* `validate`: A function that receives the current file and validates if it's a
valid test file.
* `commandFor`: A function that receives the current file and a scope to build
the command to be send to tmux.

The runner file is located on `ftplugin` folder, and it's loaded by the file
type. But it's possible to create a file on `ftdetect` to detect when autoload
the runner independently of the current file type.

Features
--------

* `TmuxRunner.setTmuxPane()` or `:SetTmuxPane`

  (Re)Selects tmux pane target to send commands and keys.

  ![TmuxRunner.setTmuxPane](/images/setTmuxPane.gif)

* `TmuxRunner.execute(text)` or `:Tmux`

  Executes a text in tmux pane. This command automatically executes
  the text.

  ![TmuxRunner.execute](/images/execute.gif)

* `TmuxRunner.sendKeys(keys)`

  Sends keys to tmux pane, you can send more than one combination of
  keys splitted by space.

  ![TmuxRunner.sendKeys](/images/sendKeys.gif)

* `TmuxRunner.register(runner)`

  Registers a Runner

* `TmuxRunner.selectRunner()` or `:SelectTmuxRunner`

  ![TmuxRunner.selectRunner](/images/selectRunner.gif)

* `TmuxRunner.run(scope)`

  Runs selected runner with given scope.

  ![TmuxRunner.run](/images/run.gif)

* `:MapTmuxCmd`

  Creates a map for a command in the current session.

  ![TmuxRunner.MapTmuxCmd](/images/MapTmuxCmd.gif)

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
        noremap <leader>rr :call TmuxRunner.sendKeys('C-c C-l') \|
              \ call TmuxRunner.reExecute()<CR>
