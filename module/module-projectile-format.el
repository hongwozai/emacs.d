;;-------------------------------------------
;;; clang-format(only little project)
;;-------------------------------------------
(module-require "clang-format")
(require 'clang-format)

;;-------------------------------------------
;;; indent function
;;-------------------------------------------
(setq indent-line-use-clang-format nil)

(defun projectile-clang-format-hook ()
  (let ((project-directory (projectile-project-p)))
    (when (and project-directory
               (locate-dominating-file project-directory ".clang-format"))

      ;; save
      (setq-local before-save-hook
                  (cons #'clang-format-buffer before-save-hook))

      (when indent-line-use-clang-format
        ;; line
        (setq-local indent-line-function #'clang-format-line)

        ;; region
        (setq-local indent-region-function #'clang-format-region)
        )
      )))

(defun clang-format-line ()
  (clang-format-region (line-beginning-position) (line-end-position)))

;;; hook
(add-hook 'c++-mode-local-vars-hook
          (lambda ()
            (projectile-clang-format-hook)))
