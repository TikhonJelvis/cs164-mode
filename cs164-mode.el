;; The easiest way to make an Emacs mode is to use the generic-mode macro.
;; Since I am inherently lazy, this is what I have done here.
;; This was loosely based off of gosu-mode at http://gosu-lang.org/downloads/gosu-mode.el

;; By: Tikhon Jelvis
(require 'generic-x)

(defvar cs164-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?' "\"'" table)
    (modify-syntax-entry ?\n "> b" table)
    table))

(defvar cs164-mode-map (make-keymap))
; (define-key cs164-mode-map (kbd "C-c C-l") 'cs164-run-file)

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
  '(("\\b[0-9]+\\b\\|null" . font-lock-constant-face)
    ("[-+*/!=<>]+" . font-lock-builtin-face)
    ("def \\([_a-zA-Z0-9]+\\)" 1 'font-lock-variable-name-face))
  ;; auto-mode-list
  '(".164\\'")
  ;; function-list
  '((lambda () 
      (set-syntax-table cs164-mode-syntax-table)
      (set (make-local-variable 'indent-line-function) 'cs164-indent-line)
      (set (make-local-variable 'cs164-basic-offset) 4)
      (use-local-map cs164-mode-map))))

(provide 'cs164-mode)
