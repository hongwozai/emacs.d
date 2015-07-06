(require 'ido)
(ido-mode 1)
(ido-everywhere t)

(require-package 'flx-ido)
(flx-ido-mode 1)
(setq flx-ido-threshold 10000)

(setq ido-enable-flex-matching t)
(setq ido-use-faces t)
(setq ido-use-virtual-buffers t)
(setq ido-auto-merge-work-directories-length 0)

(provide 'init-ido)
