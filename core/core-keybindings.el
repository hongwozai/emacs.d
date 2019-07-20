;;; basic leader key
(core/leader-set-key
 "o"   (lambda () (interactive)
          (let ((split-width-threshold nil)) (org-agenda)))

 "bd" 'dired-jump
 "bs" 'revert-buffer-with-coding-system
 "bf" 'set-buffer-file-coding-system
 "bl" 'ibuffer

 "db" 'hydra-gud/body

 "fr" 'counsel-recentf
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
  (kbd "C-w")  'evil-window-map
  (kbd "M-i")  'ivy-switch-buffer
  (kbd "M-o")  'hydra-window/body)

(core/set-key minibuffer-local-map
  :state 'native
  (kbd "C-p") 'previous-history-element
  (kbd "C-n") 'next-history-element)

(core/set-key global
  :state '(normal motion)
  (kbd "C-s")     'swiper
  (kbd "M-n")     'ahs-forward
  (kbd "M-p")     'ahs-backward
  (kbd "C-;")     'ahs-edit-mode
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

(core/set-key help-mode-map
  :state '(normal motion)
  (kbd "TAB")     'forward-button
  (kbd "L")       'help-go-forward
  (kbd "R")       'help-go-back)

(with-eval-after-load 'vc-dir
  (core/set-key vc-dir-mode-map
    :state 'native
    (kbd "r")       'vc-revert))

;;; mark board
(defhydra mark-board (:color amaranth :hint nil)
  ("m" highlight-symbol "highlight-symbol" :color blue)
  ("u" unhighlight-all-symbol "unhighlight-all-symbol" :color blue)
  ("b" bookmark-set "bookmark-set" :color blue)
  ("B" bookmark-bmenu-list "list-bookmark" :color blue)
  ("j" bookmark-jump "bookmark-jump" :color blue)
  ("d" bookmark-delete "bookmark-delete" :color blue)
  ("q" nil :exit t)
  )

(define-key evil-normal-state-map (kbd "m") 'mark-board/body)

;;; gud board
(defhydra hydra-gud (:color amaranth)
  ;; vi
  ("h" backward-char)
  ("j" next-line)
  ("k" previous-line)
  ("l" forward-char)
  ;; gud
  ("t" gud-tbreak "tbreak")
  ("b" gud-break "break")
  ("d" gud-remove "nbr")
  ("p" gud-print "print")
  ("m" gud-until "move")
  ("n" gud-next "next")
  ("s" gud-step "step")
  ("c" gud-cont "cont")
  ("o" gud-finish "out")
  ("r" gud-run "run")
  ("q" nil :color blue)
  ("z"
   (lambda () (interactive) (pop-to-buffer gud-comint-buffer))
   :color blue))

(provide 'core-keybindings)
