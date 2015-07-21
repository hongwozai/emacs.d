;; winner
(require 'winner)
(winner-mode)

;; window numbering
(require-package 'window-numbering)
(custom-set-faces
 '(window-numbering-face
   ((t (:foreground "Grey" :weight bold)))))

(window-numbering-mode)

;;; autoresize window
(require-package 'golden-ratio)
(eval-after-load 'golden-ratio
  '(progn
     (setq golden-ratio-auto-scale t)
     (setq golden-ratio-exclude-modes '("gud-mode"
                                        "gdb-registers-mode"
                                        "gdb-breakpoints-mode"
                                        "gdb-threads-mode"
                                        "gdb-frames-mode"
                                        "gdb-inferior-io-mode"
                                        "gdb-locals-mode"
                                        "gdb-disassembly-mode"
                                        "gdb-memory-mode"
                                        "speedbar-mode"
                                        "dired-mode"
                                        "ediff-mode"
                                        "calc-mode"))
     (setq golden-ratio-extra-commands
           (append golden-ratio-extra-commands
                   `(,@(mapcar #'intern
                               (loop for i from 0 to 10
                                     collect (concat "select-window-"
                                                     (number-to-string i))))
                     evil-window-left
                     evil-window-right
                     evil-window-up
                     evil-window-down
                     windmove-left
                     windmove-right
                     windmove-up
                     windmove-down)))
     (defun spacemacs/no-golden-ratio-for-buffers (bufname)
       "Disable golden-ratio if BUFNAME is the name of a visible buffer."
       (and (get-buffer bufname) (get-buffer-window bufname 'visible)))
     (defun spacemacs/no-golden-ratio-guide-key ()
       "Disable golden-ratio for guide-key popwin buffer."
       (or (spacemacs/no-golden-ratio-for-buffers " *guide-key*")
           (spacemacs/no-golden-ratio-for-buffers " *popwin-dummy*")))
     (add-to-list 'golden-ratio-inhibit-functions 'spacemacs/no-golden-ratio-guide-key)))

(provide 'init-window)
