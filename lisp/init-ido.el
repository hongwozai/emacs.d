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
(setq ido-use-faces nil)
(setq ido-use-virtual-buffers t)
(setq ido-auto-merge-work-directories-length 0)
;;; flx match highlight
(setq flx-ido-use-faces t)
(set-face-foreground 'flx-highlight-face "red")
(set-face-underline  'flx-highlight-face "red")

(ido-ubiquitous-mode 1)
(setq org-completion-use-ido t)
(setq magit-completing-read-function 'magit-ido-completing-read)

(smex-initialize)
(global-set-key [remap execute-extended-command] 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;;; ido decorations
(setq ido-decorations
      '("\n   " "" "\n   " " | ..." "[" "]"
        " [No match]" " [Matched]" " [Not readable]"
        " [Too big]" " [Confirm]"))

(provide 'init-ido)
