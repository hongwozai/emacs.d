;;-------------------------------------------
;;; eshell bash completion
;;-------------------------------------------
(require-package 'bash-completion)

(defun my/eshell-bash-completion ()
  (let ((bash-completion-nospace t))
    (while (pcomplete-here
            (nth 2 (bash-completion-dynamic-complete-nocomint
                    (save-excursion (eshell-bol) (point))
                    (point)))))))

(when (or (eq system-type 'gnu/linux)
          (eq system-type 'gnu/kfreebsd)
          (eq system-type 'darwin))
  (when (require 'bash-completion nil t)
    (setq eshell-default-completion-function #'my/eshell-bash-completion)))

;;-------------------------------------------
;;; eshell prompt
;;-------------------------------------------
(require-package 'eshell-prompt-extras)

(unless (version< emacs-version "24.4")
  (with-eval-after-load "esh-opt"
    (autoload 'epe-theme-multiline-with-status "eshell-prompt-extras")
    (setq eshell-highlight-prompt nil
          eshell-prompt-function 'epe-theme-multiline-with-status)
    ))
