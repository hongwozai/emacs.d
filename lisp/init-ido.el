;;; swiper(include ivy)
(require-package 'swiper)
(require-package 'counsel)

(require 'ido)
(ido-mode 1)
(setq ido-everywhere nil)

(setq ido-max-prospects 19)
(setq ido-max-window-height 0.5)
(setq ido-default-buffer-method 'selected-window)
(setq ido-enable-flex-matching t)
(setq ido-use-faces t)
(setq ido-use-virtual-buffers nil)
;;; ido disable automerge work directories , use M-s
(setq ido-auto-merge-work-directories-length -1)

;;; ido decorations
(setq ido-decorations
      '("\n-> " "" "\n   " " | ..." "[" "]"
        " [No match]" " [Matched]" " [Not readable]"
        " [Too big]" " [Confirm]"))

;;; ido ignore buffers
(setq ido-ignore-buffers '("\\` " "^\*/" "^\*.*output" "^\*.*err" "^\*.*mode"
                           "^\*.*process.*" "^\*.*[Ll]og.*" "^\*.*trace*"
                           "^\*SPEEDBAR" "^\*Help.*" "^\*buff.*"
                           "^\*ag.*" "^\*Completions.*" "^\*tramp.*" ".* of .*"))

;;; ido create dir
(defun hong/ido-create-dir ()
  (interactive)
  (make-directory (concat ido-current-directory ido-text))
  (ido-reread-directory)
  )

(add-hook 'ido-setup-hook
          (lambda ()
            (define-key ido-file-completion-map (kbd "M-i")
              'hong/ido-create-dir)
            (define-key ido-common-completion-map (kbd "C-n") 'ido-next-match)
            (define-key ido-common-completion-map (kbd "C-p") 'ido-prev-match)
            ))

;;; imenu
(set-default 'imenu-auto-rescan t)

;;; ivy
(ivy-mode)
(setq ivy-height 18)
(setq ivy-format-function 'ivy-format-function-arrow)

;;; counsel
(add-hook 'after-init-hook 'counsel-mode)
(global-set-key (kbd "C-x C-f") 'ido-find-file)

(provide 'init-ido)
