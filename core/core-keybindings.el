;;; basic leader key
(core/leader-set-key
 "o"   (lambda () (interactive)
          (let ((split-width-threshold nil)) (org-agenda)))

 "bd" 'dired-jump
 "bs" 'revert-buffer-with-coding-system
 "bl" 'ibuffer

 "fr" 'counsel-recentf
 "fc" 'ffip-create-project-file

 "ha" 'counsel-apropos
 "hf" 'counsel-describe-function
 "hv" 'counsel-describe-variable
 "hm" 'describe-mode
 "hk" 'describe-key
 "hb" 'counsel-descbinds

 "im" 'counsel-semantic-or-imenu
 "kr" 'counsel-yank-pop
 "w"  'hydra-window/body

 "xb" 'ivy-switch-buffer
 "xc" 'save-buffers-kill-terminal
 "xf" 'counsel-find-file
 "xk" (lambda () (interactive) (kill-buffer (current-buffer)))
 "xs" 'save-buffer)

(core/set-key global
  :state 'native
  (kbd "RET")  'newline-and-indent
  (kbd "C-\\") 'toggle-input-method
  (kbd "M-[")  'shell-header-prev
  (kbd "M-]")  'shell-header-next)

(core/set-key minibuffer-local-map
  :state 'native
  (kbd "C-p") 'previous-history-element
  (kbd "C-n") 'next-history-element)

(core/set-key global
  :state 'normal
  (kbd "C-p")     'ffip
  (kbd "C-s")     'swiper
  (kbd "M-n")     'next-error
  (kbd "M-p")     'previous-error)

(provide 'core-keybindings)
