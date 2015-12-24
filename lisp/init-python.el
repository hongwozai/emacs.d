;;; complete, checker, doc
(require-package 'anaconda-mode)
(require-package 'company-anaconda)

(setq hong/python-version "2")
(setq hong/python-program (concat "python" hong/python-version))
(setq hong/ipython-program (concat "ipython" hong/python-version))

(setq interpreter-mode-alist
      (cons '(hong/python-program . python-mode)
            interpreter-mode-alist))

(when (executable-find hong/ipython-program)
  (setq python-shell-interpreter hong/ipython-program))

(add-hook 'python-mode-hook
          '(lambda ()
             (anaconda-mode)
             (setq-local company-backends
                         (cons 'company-anaconda company-backends))
             (eldoc-mode)
             ;; (setq electric-indent-chars (delq ?: electric-indent-chars))
             (highlight-indentation-mode)))

(add-hook 'inferior-python-mode-hook 'hong/exit)

;;; flake8 with python
(setq flycheck-python-flake8-executable
      (concat hong/python-program " -m flake8"))
(setq flycheck-python-pylint-executable
      (concat hong/python-program " -m pylint"))

(provide 'init-python)
