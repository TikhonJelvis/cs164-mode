;; The easiest way to make an Emacs mode is to use the generic-mode macro.
;; Since I am inherently lazy, this is what I have done here.
;; This was loosely based off of gosu-mode at http://gosu-lang.org/downloads/gosu-mode.el

;; By: Tikhon Jelvis
(require 'generic-x)

(defgroup cs164 nil
  "Customization variables for the glorious cs164 language mode."
  :version "23.3.1")

(defcustom cs164-basic-offset 4
  "This is the default size of one indentation. Code in
blocks (like after an if statement) will be indented by this many
spaces when you press <tab>. This probably won't work if it's
negative."
  :group 'cs164
  :type 'integer)
(defcustom cs164-python-command "python"
  "This is the command used to launch python to run your files."
  :group 'cs164
  :type '(string))
(defcustom cs164-interpreter "main.py" 
  "This is the file that will be passed to python when you run a
.164 file. Set this to an absolute path if you want to run .164
files in a directory different directory from your interpreter."
  :group 'cs164
  :type '(string))

(defun cs164-run-command ()
  (concat cs164-python-command " " cs164-interpreter))

(defvar cs164-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?' "\"'" table)
    (modify-syntax-entry ?\n "> b" table)
    table))

(defvar cs164-mode-map (make-keymap))
(define-key cs164-mode-map (kbd "C-c C-l") 'cs164-run-file)

(defun cs164-run-file ()
  (interactive)
  (let ((file-name (buffer-file-name)))
    (pop-to-buffer "*cs164*")
    (unless (eq major-mode 'shell-mode) 
      (shell (current-buffer)))
    (sleep-for 0 100)
    (delete-region (point-min) (point-max))
    (comint-simple-send (get-buffer-process (current-buffer)) 
                        (concat (cs164-run-command) " " file-name))))

(defun line-matchesp (regexp offset)
  "Return t if line matches regular expression REGEXP.  The 
selected line is chosen by applying OFFSET as a numeric 
increment or decrement away from the current line number.
This function modifies the match data that `match-beginning',
`match-end' and `match-data' access; save and restore the match
data if you want to preserve them."
  (interactive)
  (save-excursion
    (forward-line offset)
    (beginning-of-line)
    (looking-at regexp)))

(defun previous-line-matchesp (regexp)
  "Return t if previous line matches regular expression REGEXP.
This function modifies the match data that `match-beginning',
`match-end' and `match-data' access; save and restore the match
data if you want to preserve them."
  (interactive)
  (line-matchesp regexp -1))

(defun current-line-matchesp (regexp)
  "Return t if current line matches regular expression REGEXP.
This function modifies the match data that `match-beginning',
`match-end' and `match-data' access; save and restore the match
data if you want to preserve them."
  (interactive)
  (line-matchesp regexp 0))

(defun cs164-indent-line ()
  (interactive)
  "Establish a set of conditional cases for the types of lines that
point currently is on, and the associated indentation rules."
  (indent-line-to
   (cond
    ((and
      (previous-line-matchesp "^[ \t]*\\*")
      (current-line-matchesp "^[ \t]*\\*"))
     (save-excursion
       (forward-line -1)
       (current-indentation)))
    ((and
      (previous-line-matchesp "^[ \t]*/\\*")
      (current-line-matchesp "^[ \t]*\\*"))
     (save-excursion
       (forward-line -1)
       (+ (current-indentation) 1)))
    ((and
      (previous-line-matchesp "^[ \t]*\\.")
      (current-line-matchesp "^[ \t]**\\."))
     (save-excursion
       (forward-line -1)
       (current-indentation)))
    ((and
      (not (previous-line-matchesp "^[ \t]*\\."))
      (current-line-matchesp "^[ \t]*\\."))
     (save-excursion
       (forward-line -1)
       (+ (current-indentation) cs164-basic-offset)))
    ((current-line-matchesp "^[ \t]*}")
     (save-excursion
       (beginning-of-line)
       (backward-up-list)
       (current-indentation)))
    (t
     (save-excursion
       (condition-case nil
           (progn
             (beginning-of-line)
             (backward-up-list)
             (+ (current-indentation) cs164-basic-offset))
         (error 0)))))))

;; Set up the actual generic mode
(define-generic-mode 'cs164-mode
  ;; comment-list
  nil
  ;; keyword-list
  '("def"
    "if"
    "else"
    "while"
    "for"
    "in"
    "print"
    "error"
    "ite"
    "lambda")
  ;; font-lock-list
  '(("\\b\\([0-9]+\\|null\\)\\b" . font-lock-constant-face)
    ("[-+*/!=<>]+" . font-lock-builtin-face)
    ("def \\([_a-zA-Z0-9]+\\)" 1 'font-lock-variable-name-face))
  ;; auto-mode-list
  '(".164\\'")
  ;; function-list
  '((lambda () 
      (set-syntax-table cs164-mode-syntax-table)
      (set (make-local-variable 'indent-line-function) 'cs164-indent-line)
      (use-local-map cs164-mode-map))))

(provide 'cs164-mode)
