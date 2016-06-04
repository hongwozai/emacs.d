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
;;; =========================== gud =============================
(setq gdb-many-windows nil)
(setq gdb-show-main   t)

(add-hook 'gdb-mode-hook #'company-mode)

;;; set no dedicated windows
(defadvice gdb-display-buffer (after undedicated-gdb-display-buffer
                                     activate)
  (set-window-dedicated-p ad-return-value nil))
(defadvice gdb-set-window-buffer (after
                                  undedicated-gdb-display-buffer
                                  (name &optional ignore-dedi window)
                                  activate)
  (set-window-dedicated-p window nil))

;;; ======================= key binding ========================
(global-set-key (kbd "<f5>") 'compile)

(provide 'init-compile)
