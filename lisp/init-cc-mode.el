;;; ===================== eldoc doxygen =======================
;;; doxygen
(autoload 'doxygen-insert-function-comment "doxygen" "insert comment for the function at point" t)
(autoload 'doxygen-insert-file-comment "doxygen" "insert comment for file" t)

;;; ===================== cc mode config ========================
;;; include c/c++, java etc.
(defun cc-common-config ()
  ;; indent
  (setq c-default-style '((java-mode . "java")
                          (awk-mode . "awk")
                          (other . "k&r"))
        c-basic-offset  4)
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
  (font-lock-add-keywords 'c-mode '("typeof" "__attribute__" "__asm__"))

  ;; company
  (setq-local company-backends
              '(company-c-headers company-clang company-etags company-gtags))
  )

(defun hong/tags-debug-compile-setup (map)
  (define-key map (kbd "C-c C-c") 'project-compile-in-shell)
  (define-key map (kbd "C-c C-s") 'change-compile-command))

(add-hook 'c-mode-common-hook
          (lambda () (cc-common-config)))

(add-hook 'c++-mode-hook
          (lambda ()
            (c/c++-mode-config)
            (hong/tags-debug-compile-setup c++-mode-map)))

(add-hook 'c-mode-hook
          (lambda ()
            (c/c++-mode-config)
            (hong/tags-debug-compile-setup c-mode-map)))

(provide 'init-cc-mode)
