;;-------------------------------------------
;;; clang-format(only little project)
;;-------------------------------------------
(module-require "clang-format")
(require 'clang-format)

(defun projectile-clang-format-hook ()
  (let ((project-directory (projectile-project-p)))
    (when (and project-directory
               (locate-dominating-file project-directory ".clang-format"))

      ;; save
      (setq-local before-save-hook
                  (cons #'clang-format-buffer before-save-hook))
      )))

(add-hook 'c++-mode-hook
          (lambda ()
            (projectile-clang-format-hook)))
