# cs164-mode

This is a simple mode for the cs164 language we're implementing in class.

It provides syntax highlighting, basic indentation and a command for running the file.

`C-c C-l` runs the file you are currently editing with your interpreter.

## Installation

Put `cs164-mode.el` somewhere in your load path and add `(require 'cs164-mode)` to your `.emacs` file.

It should now be used automatically for files with a `.164` extension. If it isn't turned on automatically, try turning it on manually: `M-x cs164-mode`.

## Customization

By default, `C-c C-l` runs your file with the command `python main.py <file>.` However, this means it will only work if the file you're running is in the same directory as your interpreter. Happily, you can customize this behavior using `M-x customize-group` `cs164`. Here you can change both the `python` command (if you're using a special version of python) and the `main.py` if you want to put an absolute path for it instead. With an absolute path (e.g. `~/Documents/cs/164/main.py`) you should be able to run `.164` files from any directory.
