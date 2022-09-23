(defconst zy-keywords-regexp
  (rx symbol-start
      (or "break" "continue" "struct" "impl" "else" "for"
          "if" "import" "in" "return" "fn"
          "self" "var" "while" "let" "loop")
      symbol-end)
  "Zy language keywords.")

(defconst zy-constants-regexp
  (rx symbol-start
      (or "true" "false" "nil")
      symbol-end)
  "Zy language constants.")

(defconst zy-var-regexp
    (rx symbol-start "var" symbol-end
        (zero-or-more whitespace)
        (group
            (one-or-more (any alphanumeric "_"))))
    "Zy variable declaration regexp.")

(defconst zy-type-regexp
  (rx symbol-start (or "struct" "impl") symbol-end
      (one-or-more whitespace)
      (group
       (one-or-more (any alphanumeric "_"))))
  "Zy class declaration regexp.")

(defconst zy-fn-regexp
  (rx symbol-start "fn" symbol-end
      (one-or-more whitespace)
      (group
       (one-or-more (any alphanumeric "_")))
      (char ?\())
  "Zy class declaration regexp.")


(defvar zy-font-lock-keywords
  `(
    (,zy-keywords-regexp . font-lock-keyword-face)
    (,zy-constants-regexp . font-lock-constant-face)
    (,zy-var-regexp 1 font-lock-variable-name-face)
    (,zy-type-regexp 1 font-lock-type-face)
    (,zy-fn-regexp 1 font-lock-function-name-face)
    )
  "Zy keywords highlighting.")

(defun zy-comment-or-string-p (&optional pos)
  "Return t if it's a comment or string at POS, defaulting to point."
  (save-excursion (let ((parse-result (syntax-ppss pos)))
                    (or (elt parse-result 3) (elt parse-result 4)))))

(defun zy-previous-indent ()
  "Return the indentation level of the previous non-blank line."
  (save-excursion
    (zy-goto-previous-nonblank-line)
    (current-indentation)))

(defun zy-goto-previous-nonblank-line ()
  "Move backward until on a non blank line."
  (forward-line -1)
  (while (and (looking-at "^[ \t]*$") (not (bobp)))
    (forward-line -1)))

;;;###autoload
(defun zy-calculate-indent ()
  "Return the column to which the current line should be indented."
  (interactive)

  (let* ((pos (point))
         (line (line-number-at-pos pos))
         (closing-p (save-excursion
                      (beginning-of-line)
                      (skip-chars-forward " \t")
                      (looking-at "[]})]"))))

    (save-excursion
      (zy-goto-previous-nonblank-line)
      (end-of-line)
      (skip-chars-backward " \t")
      (forward-char -1)

      (cond
       ((or (looking-at "^[ \t]*$")
            (= line (line-number-at-pos (point))))
        0)

       ;; TODO: /* */
       ((zy-comment-or-string-p pos)
        (current-indentation))

       (closing-p
        (if (looking-at "[\\[{(]")
            (current-indentation)
          (- (current-indentation) tab-width)))

       ((looking-at "[\\[{(]")
        (+ (current-indentation) tab-width))

       (t (current-indentation))))))

(defun zy-indent-to (x)
  "Indent line to X column."
  (when x
    (let (shift top beg)
      (and (< x 0) (error "Invalid nest"))
      (setq shift (current-column))
      (beginning-of-line)
      (setq beg (point))
      (back-to-indentation)
      (setq top (current-column))
      (skip-chars-backward " \t")
      (if (>= shift top) (setq shift (- shift top))
        (setq shift 0))
      (if (and (bolp)
               (= x top))
          (move-to-column (+ x shift))
        (move-to-column top)
        (delete-region beg (point))
        (beginning-of-line)
        (indent-to x)
        (move-to-column (+ x shift))))))

;;;###autoload
(defun zy-indent-line ()
  "Indent current line of Zy code."
  (interactive)
  (zy-indent-to (zy-calculate-indent)))

(define-derived-mode zy-mode prog-mode "Zy"
  "Major mode for editing Zy language."

  ;; syntax table
  (modify-syntax-entry ?/ ". 124b" zy-mode-syntax-table)
  (modify-syntax-entry ?* ". 23n" zy-mode-syntax-table)
  (modify-syntax-entry ?\n "> b" zy-mode-syntax-table)
  (modify-syntax-entry ?\\ "\\" zy-mode-syntax-table)
  (modify-syntax-entry ?+ "." zy-mode-syntax-table)
  (modify-syntax-entry ?^ "." zy-mode-syntax-table)
  (modify-syntax-entry ?% "." zy-mode-syntax-table)
  (modify-syntax-entry ?> "." zy-mode-syntax-table)
  (modify-syntax-entry ?< "." zy-mode-syntax-table)
  (modify-syntax-entry ?= "." zy-mode-syntax-table)
  (modify-syntax-entry ?~ "." zy-mode-syntax-table)

  (setq font-lock-defaults '((zy-font-lock-keywords)))

  (set (make-local-variable 'electric-indent-chars) '(?\n ?\}))

  (set (make-local-variable 'comment-start) "//")

  (set (make-local-variable 'indent-line-function) 'zy-indent-line)

  (setq-local tab-width 2)
  )

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.zy\\'"   . zy-mode))

(provide 'zy-mode)