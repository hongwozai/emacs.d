;;; conf-mode
(push '(".*config\\'" . conf-mode) auto-mode-alist)
(push '(".*profile\\'" . conf-mode) auto-mode-alist)
(push '("ssh.\\{1,2\\}config\\'" . conf-mode) auto-mode-alist)
;;; shell-script-mode
(push '("\\.*rc\\'" . sh-mode) auto-mode-alist)
(push '("\\.zsh\\'" . sh-mode) auto-mode-alist)
(push '("\\.sh\\'" . sh-mode) auto-mode-alist)
(push '("\\.bash\\'" . sh-mode) auto-mode-alist)
(push '("\\.bashrc\\'" . sh-mode) auto-mode-alist)
(push '("\\.bash_history\\'" . sh-mode) auto-mode-alist)
(push '("\\.bash_profile\\'" . sh-mode) auto-mode-alist)

;;; set path
(require 'exec-path-from-shell)
(setq exec-path-from-shell-check-startup-files nil)
(exec-path-from-shell-initialize)

;;; map
(defmacro shell-like-map-setup (map)
  `(evil-define-key 'emacs ,map
     (kbd "C-a") 'move-beginning-of-line
     (kbd "C-e") 'move-end-of-line
     (kbd "C-r") 'isearch-backward
     (kbd "C-l") 'clear-shell
     (kbd "C-k") 'kill-line
     (kbd "C-u") 'clear-before-line))

;;; ======================== shell script =============================
(evil-leader/set-key-for-mode 'sh-mode
    "cr" 'sh-execute-region)

;;; ========================== eshell =================================
(add-hook 'eshell-load-hook
          (lambda ()
            (setq eshell-save-history-on-exit nil
                  eshell-buffer-shorthand t
                  eshell-hist-ignoredups  t)))

(add-hook 'eshell-mode-hook
          (lambda ()
            (shell-like-map-setup eshell-mode-map)
            (evil-define-key 'emacs eshell-mode-map
              (kbd "C-u") 'eshell-clear-before-line
              (kbd "C-a") 'eshell-bol
              (kbd "C-r") 'eshell-find-history
              (kbd "C-p") 'eshell-previous-matching-input-from-input
              (kbd "C-n") 'eshell-next-matching-input-from-input
              (kbd "<C-backspace>") 'hong-backward-kill-word
              (kbd "M-DEL") 'hong-backward-kill-word
              (kbd "<escape>") 'evil-normal-state)
            (evil-define-key 'normal eshell-mode-map
              (kbd "i") 'evil-emacs-state
              (kbd "a") 'evil-emacs-state
              (kbd "s") 'evil-emacs-state)
            (setq-local company-backends nil)
            (add-hook 'evil-emacs-state-entry-hook
                      (lambda () (interactive) (goto-char (point-max))) nil t)
            ))

(defalias 'eshell/em #'find-file)
(defalias 'eshell/d #'dired)
(defalias 'eshell/b #'ibuffer)

;; history
(defun eshell-find-history ()
  (interactive)
  (insert (ivy-read
           "Eshell history: "
           (delete-dups
            (ring-elements eshell-history-ring)))))

;; eshell clear
(defun eshell/clear ()
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))

;;;
(defun hong-backward-kill-word ()
  (interactive)
  (let* ((start (+ (line-beginning-position)
                   (length (funcall eshell-prompt-function))))
         (end (point))
         (start (save-excursion
                  (backward-word)
                  (max (point) start))))
    (kill-region start end)))

(defun eshell-clear-before-line ()
  (interactive)
  (let ((start (+ (line-beginning-position)
                  (length (funcall eshell-prompt-function))))
        (end (point)))
    (delete-region start end)))

;;; ============================= shell comint =============================
;;; shell environment
(defun hong--setup-shell-environment ()
  (let ((p (get-buffer-process (buffer-name))))
    (comint-send-string p "export TERM=xterm-256color\n")
    (comint-send-string p "alias ls='ls --color=auto'\n")))

;;; shell
(setq shell-file-name "/bin/bash")
(setq explicit-shell-file-name "/bin/bash")
(add-hook 'shell-mode-hook 'hong/exit)
(add-hook 'shell-mode-hook
          (lambda ()
            (setq comint-input-sender #'hong/shell-comint-input-sender)))

;;; comint mode
(add-hook 'comint-mode-hook
          (lambda ()
            (shell-like-map-setup comint-mode-map)
            (evil-define-key 'emacs comint-mode-map
              (kbd "C-n")    'comint-next-input
              (kbd "C-p")    'comint-previous-input
              (kbd "<up>")   'comint-previous-input
              (kbd "<down>") 'comint-next-input)
            (evil-define-key 'emacs comint-mode-map
              (kbd "<escape>") 'evil-normal-state)
            (evil-define-key 'normal comint-mode-map
              (kbd "i") 'evil-emacs-state
              (kbd "a") 'evil-emacs-state
              (kbd "s") 'evil-emacs-state)
            (add-hook 'evil-emacs-state-entry-hook
                      (lambda () (interactive) (goto-char (point-max))) nil t)
            (setq-local comint-prompt-read-only t)
            (setq-local comint-move-point-for-output 'others)
            (setq-local comint-history-isearch t)))

;;; xterm-color
(require 'xterm-color)
(with-eval-after-load 'shell
  (require 'xterm-color)
  (progn (add-hook 'comint-preoutput-filter-functions 'xterm-color-filter)
         (setq comint-output-filter-functions
               (remove 'ansi-color-process-output comint-output-filter-functions))
         (setq font-lock-unfontify-region-function 'xterm-color-unfontify-region)))
;;; ============================== misc ==================================
;;; shotcuts key
(global-set-key (kbd "<f2>") 'eshell)
(defalias 'sh   'shell)
(defalias 'esh  'eshell)

(defun clear-before-line ()
  (interactive)
  (let ((start (save-excursion
                 (beginning-of-line)
                 (point)))
        (end (point)))
    (delete-region start end)))

(defun clear-shell ()
  (interactive)
  (let ((inhibit-read-only t))
    (unless (eq (line-number-at-pos) 1)
      (forward-line -1)
      (delete-region (point-min) (1+ (line-end-position)))))
  (goto-char (point-max)))

(defun hong/shell-run ()
  (interactive)
  (let* ((buffer-name "*shell*")
         (buffer (get-buffer buffer-name))
         (window (and buffer (get-buffer-window buffer))))
    (cond ((and buffer window) (select-window window))
          ((or buffer window) (pop-to-buffer buffer))
          (t (pop-to-buffer buffer-name)
             (shell)))))

(defadvice shell-command (after hong/shell-command-quit activate)
  (let ((window (get-buffer-window "*Shell Command Output*")))
    (when window
      (select-window window)
      (evil-local-set-key 'normal (kbd "q")
                          '(lambda () (interactive)
                            (kill-this-buffer) (delete-window))))))

;;; clear, man, em, ssh, exit
(defun hong/shell-comint-input-sender (proc command)
  (cond ((string-match "^[ \t]*clear[ \t]*$" command)
         (comint-send-string proc "\n")
         (let ((inhibit-read-only t))
           (erase-buffer)))
        ((string-match "^[ \t]*man[ \t]*\\(.*\\)" command)
         (comint-send-string proc "\n")
         (setq command (match-string 1 command))
         (funcall #'man command))
        ((string-match "^[ \t]*em[ \t]+\\(.*\\)" command)
         (comint-send-string proc "\n")
         (setq command (file-truename (match-string 1 command)))
         (switch-to-buffer
          (funcall #'find-file-noselect command)))
        ((string-match "^[ \t]*ssh[ \t]*\\(.*\\)@\\([^:]*\\)" command)
         (comint-send-string proc (concat command "\n"))
         (setq-local comint-file-name-prefix
                     (concat "/" (match-string 1 command) "@"
                             (match-string 2 command) ":"))
         (cd-absolute comint-file-name-prefix))
        ((string-match "^[ \t]*exit[ \t]*" command)
         (comint-send-string proc (concat command "\n"))
         (setq-local comint-file-name-prefix "")
         (cd-absolute "~/"))
        (t (comint-simple-send proc command))))

(provide 'init-shell)
