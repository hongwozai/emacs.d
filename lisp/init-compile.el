;;; ===================== compile ===============================
;; compile
(setq compile-command "make")
(setq compilation-read-command nil)
;; (setq compilation-auto-jump-to-first-error t)
(setq compilation-window-height 14)
(setq compilation-scroll-output t)
(setq compilation-finish-function nil)

(defun change-compile-command ()
  (interactive)
  (setq compile-command
        (read-shell-command "Compile Command: " compile-command)))

;;; =========================== gud =============================
(setq gdb-many-windows nil)
(setq gdb-show-main   t)

;;; set no dedicated windows
(defadvice gdb-display-buffer (after ugdb activate)
  (set-window-dedicated-p ad-return-value nil))

(defadvice gdb-set-window-buffer
    (after ugdb2 (name &optional ignore-dedi window) activate)
  (set-window-dedicated-p window nil))

;;; switch
(defun hong-switch-gud ()
  (interactive)
  (pop-to-buffer gud-comint-buffer))

(provide 'init-compile)
