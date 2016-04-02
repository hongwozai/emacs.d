;;; ===================== compile ==================
(defun hong/my-compile-common-config ()
  ;; compile
  (setq compile-command "make")
  (setq compilation-read-command nil)
  ;; (setq compilation-auto-jump-to-first-error t)
  (setq compilation-finish-function nil)
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

(defun hong/run-make (&optional with-target)
  (interactive)
  (setq make-path (hong/find-makefile-from-current))
  (if make-path
      (let* ((target (or (and with-target
                              (completing-read "Select target: "
                                               (hong/get-make-targets make-path)))
                         " ")))
        (compilation-start (format "cd %s && make %s" make-path target))
        (select-window (get-buffer-window "*compilation*")))
    (message "NO MAKEFILE!")))

;;; comint shell
(defun hong/shell-run ()
  (interactive)
  (let* ((buffer-name "*shell*")
         (buffer (get-buffer buffer-name))
         (window (and buffer (get-buffer-window buffer))))
    (cond ((and buffer window) (select-window window))
          ((or buffer window) (pop-to-buffer buffer))
          (t (pop-to-buffer buffer-name)
             (shell)))))

(defun hong/change-compile-command ()
  (interactive)
  (setq compile-command
        (read-string "Compile Command: " compile-command)))

(defun hong/shell-compile ()
  (interactive)
  (save-selected-window
    (let* ((path (hong/find-makefile-from-current))
           (rpath (and path (if (file-remote-p path)
                                (progn (string-match "/.*:\\(.*\\)$" path)
                                       (match-string 1 path))
                              path)))
           (buffer-name "*shell*")
           (command (and path compile-command)))
      (if path
          (progn
            (hong/shell-run)
            (comint-send-string (get-buffer-process buffer-name)
                                (format "cd %s/ && %s \n" rpath command))
            (setq compile-command command)
            )
        (message "NO MAKEFILE")))))

;;; =========================== auto gud =============================
(setq gdb-many-windows nil)
(setq gdb-show-main   t)

(add-hook 'gdb-mode-hook
          '(lambda () (company-mode)
             (hong/exit)))

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
