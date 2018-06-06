;;-------------------------------------------
;;; basic option
;;-------------------------------------------
(defun cc-basic-config ()
  "C/C++ both config"

  (setq c-default-style '((c-mode . "k&r")
                          (c++-mode . ""))
        c-basic-offset  4)

  ;; indent (# left align)
  (setq c-electric-pound-behavior '(alignleft))

  (c-set-offset 'inline-open 0)

  ;; related file
  (setq-local cc-search-directories
              '("." ".."
                "../inc" "../Inc"
                "../include" "../Include"
                "../src" "../source"
                "../Src" "../Source"
                "/usr/include" "/usr/local/include/"))

  ;; keywords
  (font-lock-add-keywords nil
   '("typeof" "__attribute__" "__asm__"
     ("\\<\\(FIXME\\|NOTE\\|TODO\\):" 1 'font-lock-warning-face prepend)))
  )

;;; install
(dolist (hook '(c-mode-hook c++-mode-hook))
  (add-hook 'c-mode-common-hook #'cc-basic-config))

;;; .h -> c++-mode
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;;-------------------------------------------
;;; cquery
;;-------------------------------------------
(require-package 'cquery)
(autoload 'lsp-cquery-enable "cquery")

;;-------------------------------------------
;;; packaging
;;-------------------------------------------
(defun ide-feature-enable ()
  (interactive)
  (lsp-cquery-enable))

(add-hook 'c-mode-common-hook
          #'(lambda () (ignore-errors (lsp-cquery-enable))))