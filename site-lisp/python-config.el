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
    (when (eglot-current-server)
      (call-interactively #'eglot-reconnect))
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

;;;###autoload
(defun py-activate (venv-path)
  (interactive
   (list (if-let* ((prefix (not current-prefix-arg))
                   (proj (project-current))
                   (root (project-root proj))
                   (venv-path
                    (expand-file-name ".venv" (expand-file-name root))))
             ;; then
             venv-path
           ;; else
           (directory-file-name
            (read-directory-name "Read VEnv Directory:")))))
  (if (file-exists-p venv-path)
      (py--activate-venv venv-path)
    (message "no venv %s" venv-path)))

;;;###autoload
(defun py-deactivate ()
  (interactive)
  (py--deactivate-venv))

;; first, we update modeline
(py--update-mode-line)

(provide 'python-config)