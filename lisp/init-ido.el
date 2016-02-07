;;; flx-ido
(require-package 'flx-ido)
(require-package 'ido-ubiquitous)
(require-package 'smex)

(require 'ido)
(ido-mode 1)
(ido-everywhere t)

(setq ido-max-window-height 0.5)
(setq ido-default-buffer-method 'selected-window)
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)
(setq ido-use-virtual-buffers t)
;;; ido disable automerge work directories , use M-s
(setq ido-auto-merge-work-directories-length -1)

;;; flx ido setting
(flx-ido-mode 1)
(setq flx-ido-threshold 10240)
(setq flx-ido-use-faces t)
(set-face-foreground 'flx-highlight-face "red")
(set-face-underline  'flx-highlight-face "red")

(ido-ubiquitous-mode 1)
(setq org-completion-use-ido t)
(setq magit-completing-read-function 'magit-ido-completing-read)

;;; smex
(smex-initialize)
(global-set-key [remap execute-extended-command] 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(setq smex-history-length 20)

;;; ido decorations
(setq ido-decorations
      '("\n   " "" "\n   " " | ..." "[" "]"
        " [No match]" " [Matched]" " [Not readable]"
        " [Too big]" " [Confirm]"))

;;; ido ignore buffers
(setq ido-ignore-buffers '("\\` " "^\*/" "^\*.*output" "^\*.*err" "^\*.*mode"
                           "^\*.*process.*" "^\*.*[Ll]og.*" "^\*.*trace*"
                           "^\*SPEEDBAR" "^\*Help*" "^\*buff*"
                           "^\*ag*" "^\*Completions*"))

;;; ido create dir
(defun hong/ido-create-dir ()
  (interactive)
  (make-directory (concat ido-current-directory ido-text))
  (ido-reread-directory)
  )

(define-key ido-file-completion-map (kbd "M-i") 'hong/ido-create-dir)

;;; ido vertical-mode
(require-package 'ido-vertical-mode)
(setq ido-vertical-show-count t)
(ido-vertical-mode 1)
(setq ido-vertical-define-keys #'C-n-C-p-up-and-down)

(setq ido-use-faces t)
(set-face-attribute 'ido-vertical-first-match-face nil
                    :foreground "orange" :background "gray15")
(set-face-attribute 'ido-vertical-only-match-face nil
                    :foreground "orange" :background "gray1")

;;; imenu
(set-default 'imenu-auto-rescan t)

(provide 'init-ido)
