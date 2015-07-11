;;; flx-ido
(require-package 'flx-ido)
(require-package 'ido-ubiquitous)
(require-package 'smex)

(require 'ido)
(ido-mode 1)
(ido-everywhere t)
(flx-ido-mode 1)
(setq flx-ido-threshold 10000)
(setq ido-default-buffer-method 'selected-window)

(setq ido-enable-flex-matching t)
(setq ido-use-faces t)
;; (setq ido-use-filename-at-point t)
(setq ido-use-virtual-buffers t)
(setq ido-auto-merge-work-directories-length 0)

(ido-ubiquitous-mode 1)
(setq org-completion-use-ido t)
(setq magit-completing-read-function 'magit-ido-completing-read)

(smex-initialize)
(global-set-key [remap execute-extended-command] 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

(provide 'init-ido)
