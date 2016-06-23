;;; =================== isearch ======================
;;; occur inside isearch
(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)
;;; isearch (.*? replace space, use C-q SPC insert SPC)
(define-key isearch-mode-map (kbd "SPC")
  '(lambda () (interactive)
    (setq isearch-message (concat isearch-message ".*?"))
    (setq isearch-string (concat isearch-string ".*?"))
    (isearch-push-state)
    (isearch-update)))

;;; =================== grep =========================
(setq-default grep-hightlight-matches     t
              grep-scroll-output          nil)

(setq grep-command "grep -nH -E -e ")
(setq hong-grep-files-aliases
      '((c-mode . "*.[ch] *.cpp *.hpp *.cc *.C *.cxx")
        (c++-mode . "*.[ch] *.cpp *.hpp *.cc *.C *.cxx")
        (emacs-lisp-mode . "*.el")))

(with-eval-after-load 'grep
  (defun grep-read-files (regexp)
    (read-string "Search Files: "
                 (let ((str (assoc major-mode hong-grep-files-aliases)))
                   (if str (cdr str) "*"))))
  )

;;; =================== ag ============================
(when (executable-find "ag")
  (require-package 'ag)
  (require-package 'wgrep-ag)
  (setq-default ag-highlight-search t)
  (setq-default ag-reuse-buffers t)
  (setq-default ag-reuse-window nil)

  (hong/select-buffer-window ag "*ag search*")
  )

;;; =================== occur =========================
;;; occur follow
(defun occur-np (np)
  (lexical-let ((np np))
    (lambda () (interactive)
       (save-selected-window
         (if (eq np 'next) (occur-next) (occur-prev))
         (occur-mode-goto-occurrence-other-window)
         (recenter)
         (hl-line-mode 1)))))

(defadvice isearch-occur (after hong/occur-exit-isearch activate)
  (and (ignore-errors (select-window (get-buffer-window "*Occur*")))
       (isearch-exit)))

(add-hook 'occur-mode-hook
          (lambda ()
            (evil-local-set-key 'motion (kbd "e") 'occur-edit-mode)
            (evil-local-set-key 'motion (kbd "n") (occur-np 'next))
            (evil-local-set-key 'motion (kbd "p") (occur-np 'prev))
            (evil-local-set-key 'motion (kbd "RET") #'occur-mode-goto-occurrence-other-window)))

(provide 'init-search)
