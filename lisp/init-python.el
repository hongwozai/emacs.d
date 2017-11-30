;;; elpy
;;; pip install jedi flake8 importmagic
(require-package 'elpy)

(elpy-enable)

;;; flymake -> flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (setq elpy-modules (delq 'elpy-module-highlight-indentation elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;;; define key
(evil-define-key 'normal python-mode-map
  ;; Note: C-u M-.
  (kbd "M-.") 'elpy-goto-definition
  (kbd "M-,") 'pop-tag-mark
  (kbd "M-?") 'elpy-doc
  )

(evil-leader/set-key-for-mode 'python-mode
    "cc" 'elpy-shell-send-region-or-buffer)

(add-hook 'inferior-python-mode-hook 'hong/exit)

(provide 'init-python)
