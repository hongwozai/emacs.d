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
;;; ido disable automerge work directories , use M-s
(setq ido-auto-merge-work-directories-length -1)

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

;;; ido ignore buffers
(setq ido-ignore-buffers '("\\` " "^\*/" "^\*.*output" "^\*.*err" "^\*.*mode"
                           "^\*.*process.*" "^\*.*[Ll]og.*" "^\*.*trace*"))

;;; ido vertical-mode
(require-package 'ido-vertical-mode)
(setq ido-vertical-show-count t)
(ido-vertical-mode 1)

(setq ido-use-faces t)
(set-face-attribute 'ido-vertical-first-match-face nil
                    :foreground "orange")

;;; imenu
(set-default 'imenu-auto-rescan t)

(provide 'init-ido)
