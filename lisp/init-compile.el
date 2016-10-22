;;; ===================== compile ===============================
(defun hong/my-compile-common-config ()
  ;; compile
  (setq compile-command "make")
  (setq compilation-read-command nil)
  ;; (setq compilation-auto-jump-to-first-error t)
  (setq compilation-window-height 14)
  (setq compilation-scroll-output t)
  (setq compilation-finish-function nil)
  (hong/select-buffer-window compile "*compilation*")
  )

(add-hook 'after-init-hook 'hong/my-compile-common-config)

(defun change-compile-command ()
  (interactive)
  (setq compile-command
        (read-shell-command "Compile Command: " compile-command)))

;;; keybindings
(global-set-key (kbd "<f5>") 'compile)

;;; =========================== gud =============================
(setq gdb-many-windows nil)
(setq gdb-show-main   t)

(add-hook 'gdb-mode-hook #'company-mode)

;;; set no dedicated windows
(defadvice gdb-display-buffer (after ugdb activate)
  (set-window-dedicated-p ad-return-value nil))

(defadvice gdb-set-window-buffer
    (after ugdb2 (name &optional ignore-dedi window) activate)
  (set-window-dedicated-p window nil))

;;; keybindings
(defhydra hydra-gud (:color pink :hint nil)
  ("h" evil-backward-char)
  ("j" evil-next-line)
  ("k" evil-previous-line)
  ("l" evil-forward-char)
  ;; command
  ("t" gud-tbreak "tbreak")
  ("b" gud-break "break")
  ("d" gud-remove "clear")
  ("n" gud-next "next")
  ("s" gud-step "step")
  ("c" gud-cont "continue")
  ("o" gud-finish "finish")
  ("r" gud-run "run")
  ("q" hong-switch-gud "quit" :color blue))

;;; switch
(defun hong-switch-gud ()
  (interactive)
  (pop-to-buffer gud-comint-buffer))

(provide 'init-compile)
