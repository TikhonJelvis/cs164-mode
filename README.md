# cs164-mode

The mode has been updated for pa2! To upgrade, just replace your old `cs164-mode.el` file with a current copy, then go to your `.emacs` file and enter `M-x eval-buffer` (this reloads your `.emacs` file).

This is a simple mode for the cs164 language we're implementing in class.

It provides syntax highlighting, basic indentation and a command for running the file.

`C-c C-l` runs the file you are currently editing with your interpreter.

`C-c C-p` runs your file through the parser, outputting a nicely formatted AST.

## Installation

Put `cs164-mode.el` somewhere in your load path and add `(require 'cs164-mode)` to your `.emacs` file.

It should now be used automatically for files with a `.164` extension. If it isn't turned on automatically, try turning it on manually: `M-x cs164-mode`.

## Customization

You can customize this mode using `M-x customize-group` `cs164`.

There are two options for indentation:

  * You can set how many spaces to indent by; this is 4 by default.
  * You can toggle automatic indentation. With it on, code will be indented each time you enter a newline or type a `}`.

The commands used to run your program can also be changed:

  * If you are using a custom version of python, you need to change the python command used.
  * If you want to use your interpreter from any directory, change the base directory to an absolute path containing your main.py file (e.g. `~/Documents/164/cs164sp12/pa1/`).
  * You can also change the interpreter and parser files, but this should not be necessary unless you're doing something completey nonstandard.

You can also change whether the output from old run and parse commands is cleared by new ones.
