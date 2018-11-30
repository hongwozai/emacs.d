;;; basic leader key
(core/leader-set-key
 "o"   (lambda () (interactive)
          (let ((split-width-threshold nil)) (org-agenda)))

 "bd" 'dired-jump
 "bs" 'revert-buffer-with-coding-system
 "bf" 'set-buffer-file-coding-system
 "bl" 'ibuffer

 "fr" 'counsel-recentf
 "fs" 'find-file-in-project-by-selected
 "fc" 'ffip-create-project-file
 "fl" 'counsel-locate
 "fo" 'find-file-other-window

 "ha" 'counsel-apropos
 "hf" 'counsel-describe-function
 "hv" 'counsel-describe-variable
 "hS" 'counsel-info-lookup-symbol
 "hm" 'describe-mode
 "hk" 'describe-key
 "hb" 'counsel-descbinds

 "im" 'counsel-semantic-or-imenu
 "kr" 'counsel-yank-pop
 "w"  'hydra-window/body
 "n"  'linum-mode

 ;; version control
 "vl" 'vc-print-log
 "vL" 'vc-print-root-log
 "vd" 'vc-dir
 "vv" 'vc-next-action

 "sa" 'core/find-all-matches

 "xb" 'ivy-switch-buffer
 "xc" 'save-buffers-kill-terminal
 "xf" 'counsel-find-file
 "xk" (lambda () (interactive) (kill-buffer (current-buffer)))
 "xs" 'save-buffer)

(core/set-key global
  :state 'native
  (kbd "RET")  'newline-and-indent
  (kbd "C-\\") 'toggle-input-method
  (kbd "C-s")  'swiper
  (kbd "M-[")  'shell-header-prev
  (kbd "M-]")  'shell-header-next
  (kbd "C-w")  'evil-window-map)

(core/set-key minibuffer-local-map
  :state 'native
  (kbd "C-p") 'previous-history-element
  (kbd "C-n") 'next-history-element)

(core/set-key global
  :state '(normal motion)
  (kbd "C-s")     'swiper
  (kbd "M-n")     'next-error
  (kbd "M-p")     'previous-error
  (kbd "C-w u")   'winner-undo
  (kbd "M-y")     'counsel-yank-pop)

;;; diff-mode
(core/set-key diff-mode-map
  :state 'normal
  (kbd "q")       'quit-window
  (kbd "n")       'diff-hunk-next
  (kbd "p")       'diff-hunk-prev
  (kbd "o")       'diff-goto-source)

(core/set-key special-mode-map
  :state 'normal
  (kbd "q")       'quit-window)

(with-eval-after-load 'vc-dir
  (core/set-key vc-dir-mode-map
    :state 'native
    (kbd "r")       'vc-revert))

(provide 'core-keybindings)
