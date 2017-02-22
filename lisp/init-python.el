;;; anaconda
(require-package 'elpy)

(elpy-enable)

;;; flymake -> flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;;; define key
(evil-define-key 'normal python-mode-map
  (kbd "M-.") 'elpy-goto-definition
  (kbd "M-,") 'pop-tag-mark
  (kbd "M-?") 'elpy-doc
  )

(provide 'init-python)
