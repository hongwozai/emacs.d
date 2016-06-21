;;; ===================== eldoc doxygen =======================
;;; doxygen
(autoload 'doxygen-insert-function-comment "doxygen" "insert comment for the function at point" t)
(autoload 'doxygen-insert-file-comment "doxygen" "insert comment for file" t)

;;; ===================== cc mode config ========================
;;; include c/c++, java etc.
(defun cc-common-config ()
  ;; indent
  (setq c-default-style '((c-mode . "linux")
                          (java-mode . "java")
                          (awk-mode . "awk")
                          (other . "k&r"))
        c-basic-offset  4)

  ;; auto indent
  (c-toggle-hungry-state 1)
  )

(defun c/c++-mode-config ()
  "C/C++ only"
  ;; indent
  (setq c-electric-pound-behavior '(alignleft))

  ;; related file
  (setq-local cc-search-directories
              '("." "../inc" "../include" "../src" "../source"
                "/usr/include" "/usr/local/include/*"))

  ;; keywords
  (font-lock-add-keywords nil '("typeof" "__attribute__" "__asm__") t)

  ;; company
  (setq-local company-backends
              '(company-c-headers company-clang company-etags company-gtags))

  ;; company clang not remote
  (let ((file (buffer-file-name)))
    (when (and file (file-remote-p file))
      (setq-local company-backends
                  (remove 'company-clang company-backends))))
  )

(defun hong/tags-debug-compile-setup ()
  (evil-local-set-key 'normal (kbd "M-.") 'ggtags-find-definition)
  (evil-local-set-key 'normal (kbd "M-,") 'ggtags-prev-mark)
  (local-set-key (kbd "C-c C-c") 'project-compile-in-shell)
  (local-set-key (kbd "C-c C-s") 'change-compile-command))

(add-hook 'c-mode-common-hook
          (lambda () (cc-common-config)))

(add-hook 'c++-mode-hook
          (lambda ()
            (c/c++-mode-config)
            (hong/tags-debug-compile-setup)))

(add-hook 'c-mode-hook
          (lambda ()
            (c/c++-mode-config)
            (hong/tags-debug-compile-setup)))

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(provide 'init-cc-mode)
