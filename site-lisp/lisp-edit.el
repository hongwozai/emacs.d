;; from paredit
(require 'thingatpt)

(defun lisp-edit-forward ()
  (interactive)
  (when (= (+ (point) 1) (line-end-position))
    (goto-char (line-end-position)))
  (forward-sexp))

(defun lisp-edit-up-list ()
  (interactive)
  (when (= (+ (point) 1) (line-end-position))
    (goto-char (line-end-position)))
  (up-list))

(defun lisp-edit-insert-round ()
  (interactive)
  (let* ((end (if (use-region-p) (use-region-end)
                (save-excursion (forward-sexp) (point)))))
    (insert "(")
    (save-excursion
      (forward-sexp)
      (insert ")"))))

;; M-s paredit-splice-sexp
(defun lisp-edit-splice-sexp ()
  (interactive)
  (let (start end)
    (ignore-errors
      (save-excursion
        (backward-up-list)
        (setq start (point))
        (forward-sexp)
        (setq end (point))))
    (and start end
         (save-excursion
           (goto-char end)
           (delete-char -1)
           (goto-char start)
           (delete-char 1)))))

;; M-r paredit-raise-sexp
(defun lisp-edit-raise-sexp ()
  (interactive)
  (save-excursion
    (let* ((start (save-excursion
                    (forward-sexp)
                    (backward-sexp) (point)))
           (end (save-excursion (forward-sexp) (point)))
           (text (buffer-substring start end)))
      (backward-up-list)
      (delete-region (point) (scan-sexps (point) 1))
      (let* ((indent-start (point))
             (indent-end (save-excursion (insert text) (point))))
        (indent-region indent-start indent-end)))))

;; C-k paredit-kill
(defun lisp-edit-kill-line ()
  (interactive)
  (save-excursion
    (forward-sexp)
    (backward-sexp)
    (let ((start (point))
          (end (save-excursion (up-list) (point))))
      (delete-region start (- end 1)))))

(defun lisp-edit-define-keys (map)
  (when (featurep 'evil)
    (evil-define-key 'normal map
      (kbd "W") #'lisp-edit-forward
      (kbd "B") #'backward-sexp
      (kbd "(") #'backward-up-list
      (kbd ")") #'lisp-edit-up-list
      (kbd "M-(") #'lisp-edit-insert-round
      (kbd "M-s") #'lisp-edit-splice-sexp
      (kbd "M-r") #'lisp-edit-raise-sexp
      (kbd "C-k") #'lisp-edit-kill-line
      (kbd "C-M-k") #'kill-sexp
      )))

(provide 'lisp-edit)