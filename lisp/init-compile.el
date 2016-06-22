;;; ====================== compile func ==========================
(defun project--get-root (&optional iscurr)
  "Get project root path."
  (or (ffip-project-root)
      (if iscurr default-directory)))

(defun project-compile ()
  (interactive)
  (let ((default-directory (project--get-root t)))
    (compile compile-command)))

(defun project-compile-in-shell ()
  (interactive)
  (save-selected-window
    (let* ((path (project--get-root))
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
            (setq compile-command command))
        (message "CANNOT COMPILE!")))))

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
(defadvice gdb-display-buffer (after ugdb activate)
  (set-window-dedicated-p ad-return-value nil))

(defadvice gdb-set-window-buffer
    (after ugdb2 (name &optional ignore-dedi window) activate)
  (set-window-dedicated-p window nil))

;;; ======================= key binding ========================
(global-set-key (kbd "<f5>") 'compile)

(provide 'init-compile)
