;;-------------------------------------------
;;; virtualenv
;;-------------------------------------------
(defvar py--current-venv-path (getenv "VIRTUAL_ENV"))
(defvar py--current-venv-name
  (when-let* ((prompt (getenv "VIRTUAL_ENV_PROMPT"))
              (dirname (string-trim prompt "[ ()]+" "[ ()]+"))
              (name (format " (py:%s) " dirname)))
    name))

(defvar py--origin-venv-path py--current-venv-path)
(defvar py--origin-venv-name py--current-venv-name)

(defun py--update-mode-line ()
  (setq venv-mode-string py--current-venv-name)
  (force-mode-line-update t))

(defun py--venv-name (venv-path)
  (let* ((venv-path (expand-file-name venv-path))
         (origin-name (file-name-nondirectory venv-path))
         (name (if (equal origin-name ".venv")
                   (file-name-nondirectory
                    (directory-file-name
                     (file-name-directory venv-path)))
                 origin-name)))
    name))

(defun py--maybe-activate-venv (venv-path)
  (py--activate-venv venv-path))

(defun py--activate-venv (venv-path)
  (let* ((venv-bin (concat (file-name-as-directory venv-path) "bin"))
         (venv-name (py--venv-name venv-path)))
    ;; modify venv-path
    (setq py--current-venv-path venv-path)
    (setq py--current-venv-name (format " (py:%s) " venv-name))
    (setq exec-path (cons venv-bin exec-path))
    (setenv "VIRTUAL_ENV" venv-path)
    (setenv "VIRTUAL_ENV_PROMPT" venv-name)
    (setenv "PATH" (concat venv-bin path-separator (getenv "PATH")))
    ;; modify finished
    (py--update-mode-line)
    ;; start lsp server
    (if (eglot-current-server)
        (call-interactively #'eglot-reconnect)
      (eglot-ensure))
    (message "python venv %s activate already" py--current-venv-name)))

(defun py--deactivate-venv ()
  (let* ((venv-path py--current-venv-path)
         (venv-bin (concat (file-name-as-directory venv-path) "bin")))
    ;; modify venv-path
    (setq exec-path (delete venv-bin exec-path))
    (setenv "PATH"
            (mapconcat 'identity
                       (delete venv-bin (split-string (getenv "PATH") path-separator))
                       path-separator))
    (setenv "VIRTUAL_ENV" py--origin-venv-path)
    (setenv "VIRTUAL_ENV_PROMPT" py--origin-venv-name)
    (setq py--current-venv-path py--origin-venv-path)
    (setq py--current-venv-name py--origin-venv-name)
    ;; modify finished
    (py--update-mode-line)
    (when (eglot-current-server)
      (call-interactively #'eglot-reconnect))
    (message "python venv %s deactivate already" py--current-venv-name)))

(defun py--project-venv ()
  (when-let* ((proj (project-current))
              (root (project-root proj))
              (venv-path
               (expand-file-name ".venv" (expand-file-name root))))
    ;; then
    venv-path))

(defun py--find-interpreter (venv-path)
  ;; 如果能在本venv找到ipython，那么才使用ipython
  (when-let* ((dir (file-name-as-directory
                    (concat (file-name-as-directory venv-path) "bin")))
              (ipy (executable-find (concat dir "ipython"))))
    ;; shell interpreter
    (setq-local python-shell-interpreter "ipython")
    (setq-local python-shell-interpreter-args "-i --simple-prompt")))

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

;; first, we update modeline
(py--update-mode-line)

;;-------------------------------------------
;;; filter
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
         (venv-path py--current-venv-path))
    ;; switch interpreter
    (py--find-interpreter venv-path)))

(add-hook 'python-mode-hook 'py-mode-hook-function)
(add-hook 'python-ts-mode-hook 'py-mode-hook-function)

(when *is-mac*
  (with-eval-after-load 'comint
    (add-hook 'comint-preoutput-filter-functions #'py--comint-filter nil t))

  (with-eval-after-load 'eldoc
    (advice-add 'eldoc--message :around #'py--eldoc-filter)))

(provide 'python-config)