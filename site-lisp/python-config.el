;;-------------------------------------------
;;; virtualenv
;;-------------------------------------------
(defun py--update-mode-line (venv-name)
  (setq-local venv-mode-string venv-name)
  (force-mode-line-update t))

(defun py--venv-name (venv-path)
  (let* ((venv-path (expand-file-name venv-path))
         (origin-name (file-name-nondirectory venv-path))
         (name (if (equal origin-name ".venv")
                   (file-name-nondirectory
                    (directory-file-name
                     (file-name-directory venv-path)))
                 origin-name)))
    (format " v:%s " name)))

(defun py--maybe-activate-venv (venv-path)
  (py--activate-venv venv-path))

(defun py--activate-venv (venv-path)
  (let* ((venv-bin (concat (file-name-as-directory venv-path) "bin"))
         (venv-name (py--venv-name venv-path)))
    ;; modify venv-path
    (setq-local exec-path (cons venv-bin exec-path))
    ;; process-environment must be local varitable
    (make-variable-buffer-local 'process-environment)
    (setenv "VIRTUAL_ENV" venv-path)
    (setenv "VIRTUAL_ENV_PROMPT" venv-name)
    (setenv "PATH" (concat venv-bin path-separator (getenv "PATH")))
    ;; modify finished
    (py--update-mode-line venv-name)
    (message "python venv %s activate already" venv-name)))

;; 当前 buffer 是否能找到找到 venv
(defun py--project-venv ()
  (when-let* ((proj (project-current))
              (root (project-root proj))
              (venv-path
               (expand-file-name ".venv" (expand-file-name root))))
    ;; then
    venv-path))

;; 如果能在本venv找到ipython，那么才使用ipython
(defun py--find-interpreter (venv-path)
  (let ((venv-dir (file-name-as-directory
                   (concat (file-name-as-directory venv-path) "bin"))))
    (if-let (ipy (executable-find (concat venv-dir "ipython")))
        (progn (setq-local python-shell-interpreter ipy)
               (setq-local python-shell-interpreter-args "-i --simple-prompt"))
      (setq-local python-shell-interpreter (executable-find "python"))
      (setq-local python-shell-interpreter "-i"))))

;;;###autoload
(defun py-activate (venv-path)
  (interactive
   (list (if-let* ((prefix (not current-prefix-arg))
                   (venv-path (py--project-venv)))
             ;; then
             venv-path
           ;; else
           (directory-file-name
            (read-directory-name "Read VEnv Directory:")))))
  (if (file-exists-p venv-path)
      (progn
        (py--activate-venv venv-path)
        (py--find-interpreter venv-path))
    (message "no venv %s" venv-path)))

;;;###autoload
(defun py-deactivate ()
  (interactive)
  (py--deactivate-venv))

;;-------------------------------------------
;;; filter/hook
;;-------------------------------------------
(defun py--comint-filter (output)
  (replace-regexp-in-string "__PYTHON_EL_eval.+\n" "" output))

(defun py--eldoc-filter (orig-fun string)
  (let ((clean
         (if (stringp string)
             (replace-regexp-in-string "\n__PYTHON_EL_eval.+" "" string)
           string)))
    (funcall orig-fun clean)))

;;;###autoload
(defun py-mode-hook-function ()
  ;; find python shell interpreter
  (let* ((map (symbol-value (intern (format "%s-map" major-mode))))
         (venv-path (py--project-venv)))
    (when *is-mac*
      (setq-local python-shell-completion-native-enable nil))
    ;; switch interpreter
    (when venv-path (py-activate venv-path))
    (eglot-ensure)))

(add-hook 'python-mode-hook 'py-mode-hook-function)
(add-hook 'python-ts-mode-hook 'py-mode-hook-function)

(when *is-mac*
  (with-eval-after-load 'comint
    (add-hook 'comint-preoutput-filter-functions #'py--comint-filter nil t))

  (with-eval-after-load 'eldoc
    (advice-add 'eldoc--message :around #'py--eldoc-filter)))

(provide 'python-config)