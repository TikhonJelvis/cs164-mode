# cs164-mode

This is a simple mode for the cs164 language we're implementing in class.

It provides syntax highlighting, basic indentation and a command for running the file.

`C-c C-l` runs the file you are currently editing with your interpreter. For this to work, you have to be in the same directory as your interpreter.

## Installation

Put `cs164-mode.el` somewhere in your load path and add `(require 'cs164-mode)` to your `.emacs` file.

It should now be used automatically for files with a `.164` extension. If it isn't turned on automatically, try turning it on manually: `M-x cs164-mode`.
