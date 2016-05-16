;;; anaconda
(require-package 'anaconda-mode)
(require-package 'company-anaconda)
(require-package 'pyvenv)
(require-package 'pytest)

;;; complete, checker, doc
(with-eval-after-load 'python
  (evil-define-key 'normal python-mode-map
    (kbd "M-.") 'anaconda-mode-find-definitions
    (kbd "M-,") 'anaconda-mode-go-back)
  (add-hook 'inferior-python-mode-hook 'hong/exit))

(add-hook 'python-mode-hook
          (lambda ()
            (pyvenv-mode 1)
            (anaconda-mode 1)
            (anaconda-eldoc-mode 1)

            (setq-local company-backends
                        (cons 'company-anaconda company-backends))
            (setq-local imenu-create-index-function
                        #'python-imenu-create-flat-index)
            (setq electric-indent-chars (delq ?: electric-indent-chars))
            ))

;; pytest
(with-eval-after-load 'pytest
  (hong/select-buffer-window pytest-run "*pytest*"
                             pytest-all "*pytest*"
                             pytest-directory "*pytest*"))

(provide 'init-python)
