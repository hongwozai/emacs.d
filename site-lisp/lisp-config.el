;; from paredit
(require 'thingatpt)

(defun lisp-edit-select-comment ()
  (comment-beginning)
  (set-mark (point))
  (let ((end (next-single-property-change (point) 'face)))
    ;; 1. not face 2. newline
    (goto-char (- end 2))))

;; font-lock-comment-face
;; font-lock-comment-delimiter-face
(defun lisp-edit-auto-select ()
  (interactive)
  (cond
   ;; comment?
   ((and (nth 4 (syntax-ppss))
         (not (use-region-p)))
    (lisp-edit-select-comment))
   ;; mark more list
   (t (condition-case ()
          (progn (up-list)
                 (set-mark (point))
                 (backward-sexp))
        (scan-error
         (unless (use-region-p)
           (set-mark (point)))
         (message "At top level")
         ;; upward and ever-selective choices of parentheses
         (backward-sexp))))))

(defun lisp-edit-forward ()
  (interactive)
  ;; because evil move back in line end
  (when (and (featurep 'evil) (not evil-move-beyond-eol))
    (when (= (+ (point) 1) (line-end-position))
      (goto-char (line-end-position))))
  (cond
   ;; blank?
   ((looking-at-p "[ \t\v\r\n]")
    (skip-chars-forward " \t\v\r\n"))
   ;; comment?
   ((nth 4 (syntax-ppss))
    (goto-char (next-single-property-change (point) 'face))
    (skip-chars-forward " \t\v\r\n"))
   ;; comment-delimiter?
   ((eq (get-text-property (point) 'face)
        'font-lock-comment-delimiter-face)
    (forward-comment 1)
    (skip-chars-forward " \t\v\r\n"))
   ;; goto next sexp beginning
   (t (condition-case ()
          (progn
            (forward-sexp 1)
            ;; no skip line
            (skip-chars-forward " \t\v"))
        (scan-error
         (message "At last sexp"))))))

(defun lisp-edit-up-list ()
  (interactive)
  (when (= (+ (point) 1) (line-end-position))
    (goto-char (line-end-position)))
  (up-list))

(defun lisp-edit-insert-round ()
  (interactive)
  ;; skip whitespace
  (skip-chars-forward " \t\v\r\n")
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
  ;; lisp keys
  (define-key map (kbd "M-a") #'backward-sexp)
  (define-key map (kbd "M-e") #'lisp-edit-forward)
  (define-key map (kbd "M-(") #'lisp-edit-insert-round)
  (define-key map (kbd "M-h") #'lisp-edit-auto-select)
  (define-key map (kbd "M-S") #'lisp-edit-splice-sexp)
  (define-key map (kbd "M-R") #'lisp-edit-raise-sexp)
  (define-key map (kbd "C-k") #'lisp-edit-kill-line)
  ;; evil bind
  (when (featurep 'evil)
    (evil-define-key 'normal map
      ;; uppercase letters and lowercase letters swap functions
      (kbd "(") #'backward-up-list
      (kbd ")") #'lisp-edit-up-list
      (kbd "M-(") #'lisp-edit-insert-round
      (kbd "M-S") #'lisp-edit-splice-sexp
      (kbd "M-R") #'lisp-edit-raise-sexp
      (kbd "C-k") #'lisp-edit-kill-line)
    (evil-define-key 'insert map
      (kbd "M-(") #'lisp-edit-insert-round
      (kbd "M-h") #'lisp-edit-auto-select)
    (evil-define-key 'visual map
      (kbd "(") #'backward-up-list
      (kbd ")") #'lisp-edit-up-list)
    ;; leave the last space
    (setq-local evil-move-beyond-eol t)))

;; lisp
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq-local show-paren-style 'expression)
            (lisp-edit-define-keys emacs-lisp-mode-map)))

(add-hook 'scheme-mode-hook
          (lambda ()
            (setq-local show-paren-style 'expression)
            (lisp-edit-define-keys scheme-mode-hook)))

;; elisp
(define-key emacs-lisp-mode-map (kbd "C-c C-l") 'eval-buffer)

(provide 'lisp-config)