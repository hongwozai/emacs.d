;;; ===================== compile ==================
(defun hong/my-compile-common-config ()
  ;; compile
  (setq compile-command "make")
  (setq compilation-window-height 12)
  (setq compilation-read-command nil)
  ;; (setq compilation-auto-jump-to-first-error t)
  (setq compilation-finish-function nil)
  ;; (setq compilation-finish-function
  ;;       (lambda (buf str)
  ;;         (if (string-match "exited abnormally" str)
  ;;             (message "compilation errors, press C-x ` to visit'")
  ;;           (when (string-match "*compilation*" (buffer-name buf))
  ;;             (winner-undo)
  ;;             (message "NO COMPILATION ERRORS!")))))
  (hong/select-buffer-window compile "*compilation*")
  )

(add-hook 'after-init-hook 'hong/my-compile-common-config)

;;; ==================== auto compile =================
(defun hong/find-makefile-from-current ()

  (defun get-parent-directory (path)
    (file-name-directory (directory-file-name path)))

  (defun have-makefile (path)
    (or (file-readable-p (concat path "Makefile"))
        (file-readable-p (concat path "makefile"))))

  (let ((path (if buffer-file-name (file-name-directory buffer-file-name)
                "/"))
        (go-on t)
        (ret nil))
    (while go-on
      (if (have-makefile path)
          (progn (setq go-on nil)
                 (setq ret path))
        (progn
          (setq path (get-parent-directory path))
          (if (equal path "/")
              (setq go-on nil))
          (setq ret nil))
        ))
    ret))

(defun hong/get-make-targets (path)
  (cd path)
  (let (targets target)
    (with-temp-buffer
      (insert
       (shell-command-to-string "make -nqp 2>/dev/null"))
      ;;  after find every target
      (goto-char (point-min))
      (while (re-search-forward "^\\([^%$:#\n\t ]+\\):\\([^=]\\|$\\)" nil t)
        (setq target (match-string 1))
        (unless (or (save-excursion
                      (goto-char (match-beginning 0))
                      (forward-line -1)
                      (looking-at "^# Not a target:"))
                    (string-match "^\\." target))
          (push target targets)))
      (sort (delete-dups targets) 'string<))))

(defun hong/run-make-with-target ()
  (interactive)
  (setq make-path (hong/find-makefile-from-current))
  (if make-path
      (let* ((target (ido-completing-read "Select target: "
                                          (hong/get-make-targets make-path))))
        (compilation-start (format "cd %s && make %s" make-path target))
        (select-window (get-buffer-window "*compilation*")))
    (message "NO MAKEFILE!")
    )
  )

;;; =========================== auto gud =============================
(setq gdb-many-windows nil)
(setq gdb-show-main   t)

(add-hook 'gdb-mode-hook
          '(lambda ()
             (company-mode)
             (hong/exit)
             ))

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
