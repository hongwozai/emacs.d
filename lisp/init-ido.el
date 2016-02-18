;;; flx-ido swiper(include ivy)
(require-package 'flx-ido)
(require-package 'swiper)

(require 'ido)
(ido-mode 1)
(ido-everywhere t)

(setq ido-max-prospects 19)
(setq ido-max-window-height 0.5)
(setq ido-default-buffer-method 'selected-window)
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)
(setq ido-use-virtual-buffers t)
;;; ido disable automerge work directories , use M-s
(setq ido-auto-merge-work-directories-length -1)

(set-face-background 'ido-first-match "Grey15")
(set-face-background 'ido-only-match "Grey2")

;;; flx ido setting
(flx-ido-mode 1)
(setq flx-ido-threshold 10240)
(setq flx-ido-use-faces t)
(set-face-background 'flx-highlight-face "#e99ce8")

;;; ido decorations
(setq ido-decorations
      '("\n-> " "" "\n   " " | ..." "[" "]"
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

(add-hook 'ido-setup-hook
          (lambda ()
            (define-key ido-file-completion-map (kbd "M-i")
              'hong/ido-create-dir)))

;;; imenu
(set-default 'imenu-auto-rescan t)

;;; ivy
(ivy-mode)
(setq ivy-height 18)
(setq ivy-format-function 'ivy-format-function-arrow)

(provide 'init-ido)
