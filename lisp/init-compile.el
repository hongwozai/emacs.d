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
              (winner-undo)
              (message "NO COMPILATION ERRORS!")))))
  )

(add-hook 'after-init-hook 'hong/my-compile-common-config)
(global-set-key (kbd "<f5>") 'compile)

;;; ==================== auto test =================
(defun hong/detect-test-file-p (files)
  (unless (null files)
    (or (file-exists-p (car files))
        (hong/detect-test-file-p (cdr files)))))

(defun hong/run-autotest ()
  (interactive)
  (if (hong/detect-test-file-p '("makefile" "Makefile"))
      (hong/run-shell-command "make test")
    (message "no makefile, make test don't run!!"))
  )

(global-set-key (kbd "<f6>") 'hong/run-autotest)

(provide 'init-compile)
