(setq ido-everywhere t)
(ido-mode 1)

(require-package 'flx-ido)
(flx-ido-mode 1)

(setq ido-enable-flex-matching t)
(setq ido-use-faces t)

(provide 'init-ido)
