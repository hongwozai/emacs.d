;;; complete, checker, doc
(require-package 'anaconda-mode)
(require-package 'company-anaconda)

(setq interpreter-mode-alist
      (cons '("python3" . python-mode) interpreter-mode-alist))

(when (executable-find "ipython3")
  (setq python-shell-interpreter "ipython3"))

(add-hook 'python-mode-hook
          '(lambda ()
             (anaconda-mode 1)
             (add-to-list 'company-backends 'company-anaconda)
             (eldoc-mode 1)
             (setq electric-indent-chars (delq ?: electric-indent-chars))))

(provide 'init-python)
