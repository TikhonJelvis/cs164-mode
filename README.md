# cs164-mode

This is a simple mode for the cs164 language we're implementing in class.

It provides syntax highlighting, basic indentation and a command for running the file.

`C-c C-l` runs the file you are currently editing with your interpreter.

## Installation

Put `cs164-mode.el` somewhere in your load path and add `(require 'cs164-mode)` to your `.emacs` file.

It should now be used automatically for files with a `.164` extension. If it isn't turned on automatically, try turning it on manually: `M-x cs164-mode`.

## Customization

You can customize this mode using `M-x customize-group` `cs164`.

The number of spaces used to indent can be changed; it is 4 by default.

The commands used to run your program can also be changed:

  * If you are using a custom version of python, you need to change the python command used.
  * If you want to use your interpreter from any directory, change the interpreter from `main.py` to an absolute path like `~/Documents/cs/164/main.py`.
