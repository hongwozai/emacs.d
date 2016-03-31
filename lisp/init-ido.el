;;; ================================== ido =====================================
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

(add-hook 'ido-setup-hook
          (lambda ()
            (define-key ido-file-completion-map (kbd "C-d") 'ido-enter-dired)
            (define-key ido-file-completion-map (kbd "M-d") 'hong/ido-create-dir)
            (define-key ido-common-completion-map (kbd "C-n") 'ido-next-match)
            (define-key ido-common-completion-map (kbd "C-p") 'ido-prev-match)))

;;; imenu
(set-default 'imenu-auto-rescan t)

;;; ================================ ivy ========================================
;;; swiper(include ivy)
(require-package 'swiper)
(require-package 'counsel)

(ivy-mode)
(setq ivy-height 18)
(setq ivy-format-function 'ivy-format-function-arrow)

;;; counsel
(add-hook 'after-init-hook 'counsel-mode)
(global-set-key (kbd "C-x C-f") 'ido-find-file)

(eval-after-load 'counsel
  '(progn
     (define-key counsel-find-file-map (kbd "C-d") 'ivy-dispatching-done)
     (define-key counsel-find-file-map (kbd "M-d") 'hong/ivy-create-dir)
     (define-key counsel-find-file-map (kbd "C-j") 'ivy-immediate-done)
     (define-key counsel-find-file-map (kbd "C-m") 'ivy-alt-done)))

;;; =============================  misc function ================================
(defun hong/ido-create-dir ()
  (interactive)
  (make-directory (concat ido-current-directory ido-text))
  (ido-reread-directory))

(defun hong/ivy-create-dir ()
  (interactive)
  (make-directory (concat ivy--directory ivy-text))
  (ivy-alt-done))

(provide 'init-ido)
