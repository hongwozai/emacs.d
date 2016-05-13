;;; ================================== ido =====================================
(require 'ido)
(ido-mode 1)
(setq ido-everywhere t)

(setq ido-max-prospects 10)
(setq ido-max-window-height 0.5)
(setq ido-default-buffer-method 'selected-window)
(setq ido-enable-flex-matching t)
(setq ido-use-faces t)
(setq ido-use-virtual-buffers nil)
;;; ido disable automerge work directories , use M-s
(setq ido-auto-merge-work-directories-length -1)

;;; ido decorations
(setq ido-decorations
      '("\n-> " "" "\n   " "\n   ..." "[" "]"
        " [No match]" " [Matched]" " [Not readable]"
        " [Too big]" " [Confirm]"))

;;; ido ignore buffers
(setq ido-ignore-buffers '("\\` " "^\*/" "^\*.*output" "^\*.*err" "^\*.*mode"
                           "^\*.*process.*" "^\*.*[Ll]og.*" "^\*.*trace*"
                           "^\*SPEEDBAR" "^\*Help.*" "^\*buff.*" "^\*magit.*"
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
(ivy-mode 1)
(setq ivy-height 10)
(setq ivy-format-function 'ivy-format-function-arrow)

;;; C-c C-o ivy-occur(useful!)
(eval-after-load 'ivy
  '(progn
     (define-key ivy-minibuffer-map (kbd "C-d") 'ivy-dispatching-done)
     (define-key ivy-minibuffer-map (kbd "C-j") 'ivy-immediate-done)
     (define-key ivy-minibuffer-map (kbd "C-m") 'ivy-alt-done)
     (evil-define-key 'normal ivy-occur-mode-map
       (kbd "RET") 'ivy-occur-press
       (kbd "q") 'kill-buffer-and-window)
     (setq ivy-extra-directories nil)))

;;; counsel
(add-hook 'after-init-hook 'counsel-mode)
(global-set-key (kbd "C-x C-f") 'ido-find-file)

;;; =============================  misc function ================================
(defun hong/ido-create-dir ()
  (interactive)
  (make-directory (concat ido-current-directory ido-text))
  (ido-reread-directory))

(provide 'init-ido)
