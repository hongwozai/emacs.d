;;; anaconda
(require-package 'anaconda-mode)
(require-package 'company-anaconda)

;;; complete, checker, doc
(setq python-version "2")
(setq python-interpreter (concat "python" python-version))

(setq interpreter-mode-alist
      (cons '(python-interpreter . python-mode)
            interpreter-mode-alist))

(eval-after-load 'python
  `(progn
     (evil-define-key 'normal python-mode-map
       (kbd "M-.") 'anaconda-mode-find-definitions
       (kbd "M-,") 'anaconda-mode-go-back)))

(add-hook 'python-mode-hook
          (lambda ()
            (anaconda-mode 1)
            (anaconda-eldoc-mode 1)

            (setq-local company-backends
                        (cons 'company-anaconda company-backends))
            (setq-local imenu-create-index-function
                        #'python-imenu-create-flat-index)
            (setq electric-indent-chars (delq ?: electric-indent-chars))

            ;; flake8 with python
            (setq-local flycheck-python-flake8-executable
                        (concat python-interpreter " -m flake8"))
            (setq-local flycheck-python-pylint-executable
                        (concat python-interpreter " -m pylint"))
            ))

(add-hook 'inferior-python-mode-hook 'hong/exit)

(provide 'init-python)
