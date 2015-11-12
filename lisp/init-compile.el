;;; ===================== compile ==================
(defun hong/my-compile-common-config ()
    ;; compile
  (setq compile-command "make")
  (setq compilation-window-height 12)
  (setq compilation-read-command nil)
  ;; (setq compilation-auto-jump-to-first-error t)
  (setq compilation-finish-function
        (lambda (buf str)
          (if (string-match "exited abnormally" str)
              (message "compilation errors, press C-x ` to visit'")
            (when (string-match "*compilation*" (buffer-name buf))
              (message "NO COMPILATION ERRORS!")))))
  (hong/select-buffer-window compile "*compilation*")
  )

;;; ==================== auto test =================
(defun hong/run-make-test ()
  (interactive)
  (hong/run-shell-command "make test"))

(defun hong/run-autotest ()
  (interactive)
  (hong/run-make-test))

(global-set-key (kbd "<f6>") 'hong/run-autotest)

(provide 'init-compile)
