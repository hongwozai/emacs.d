;; company
(add-hook 'after-init-hook #'global-company-mode)

(with-eval-after-load 'company
  ;; can't work with TRAMP
  (setq company-backends (delete 'company-ropemacs company-backends))
  (setq company-idle-delay 0.2)
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-flip-when-above t)
  (setq company-tooltip-align-annotations t)
  (setq company-show-numbers t)
  (setq company-clang-insert-arguments nil)
  (setq company-gtags-insert-arguments nil)
  (setq company-etags-ignore-case t)
  ;; shell-mode -> ivy
  (setq company-global-modes
        '(not shell-mode eshell-mode term-mode))
  (setq company-ispell-dictionary
        (file-truename "~/.emacs.d/english-words.txt"))
  )

(defun hong/toggle-company-ispell ()
  (interactive)
  (cond ((memq 'company-ispell company-backends)
         (setq company-backends (delete 'company-ispell company-backends))
         (message "Company ispell disabled."))
        (t (add-to-list 'company-backends 'company-ispell)
           (message "Company ispell enabled."))))

(provide 'init-complete)
