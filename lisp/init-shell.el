;;; shell-script-mode
(push '("\\.*rc\\'" . sh-mode) auto-mode-alist)
(push '("\\.zsh\\'" . sh-mode) auto-mode-alist)
(push '("\\.sh\\'" . sh-mode) auto-mode-alist)
(push '("\\.bash\\'" . sh-mode) auto-mode-alist)
(push '("\\.bashrc\\'" . sh-mode) auto-mode-alist)
(push '("\\.bash_history\\'" . sh-mode) auto-mode-alist)
(push '("\\.bash_profile\\'" . sh-mode) auto-mode-alist)

;;; set path
(setq exec-path-from-shell-check-startup-files nil)
(exec-path-from-shell-initialize)

;;; map
(defmacro shell-like-map-setup (map)
  `(evil-define-key 'insert ,map
     (kbd "C-a") 'move-beginning-of-line
     (kbd "C-e") 'move-end-of-line
     (kbd "C-r") 'isearch-backward
     (kbd "C-l") 'clear-shell
     (kbd "C-k") 'kill-line
     (kbd "C-u") 'clear-before-line))

;;; ========================== eshell =================================
(add-hook 'eshell-load-hook
          (lambda ()
            (shell-like-map-setup eshell-mode-map)
            (evil-define-key 'insert eshell-mode-map
              (kbd "C-a") 'eshell-bol
              (kbd "C-r") 'eshell-find-history
              (kbd "C-p") 'eshell-previous-matching-input-from-input
              (kbd "C-n") 'eshell-next-matching-input-from-input)
            (setq eshell-save-history-on-exit nil
                  eshell-buffer-shorthand t)
            ))

(add-hook 'eshell-mode-hook
          (lambda ()
            (setq-local company-backends nil)
            (add-hook 'evil-insert-state-entry-hook
                      (lambda () (interactive) (goto-char (point-max))) nil t)
            ))

(defalias 'eshell/em #'find-file)
(defalias 'eshell/d #'dired)

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

;;; ============================= shell comint =============================
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
            (evil-define-key 'insert comint-mode-map
              (kbd "C-n") 'comint-next-input
              (kbd "C-p") 'comint-previous-input)
            (add-hook 'evil-insert-state-entry-hook
                      (lambda () (interactive) (goto-char (point-max))) nil t)
            (setq-local comint-prompt-read-only t)
            (setq-local comint-move-point-for-output 'others)
            (setq-local comint-history-isearch t)))

;;; ============================= term =====================================
(setq multi-term-program "/bin/bash")
(add-hook 'term-mode-hook
          (lambda ()
            ;; compatiable
            (setq-local evil-move-cursor-back nil)
            (setq-local evil-escape-inhibit t)
            ;; term
            (setq multi-term-switch-after-close nil)
            (setq multi-term-dedicated-select-after-open-p t)
            (setq multi-term-scroll-to-bottom-on-output 'others)
            (setq term-buffer-maximum-size 0)
            ;; multi-term keybinding
            (term-set-escape-char ?\C-c)
            (setq term-unbind-key-list '("C-x"))
            (setq term-bind-key-alist
                  '(("M-," . hong/switch-non-terminal-buffer)
                    ("M-:" . eval-expression)
                    ("M-w" . kill-ring-save)
                    ("C-y" . term-paste)
                    ("C-DEL" . term-send-raw-meta)
                    ("M-d" . term-send-forward-kill-word)
                    ("M-x" . execute-extended-command)
                    ("M-]" . multi-term-next)
                    ("TAB" . (lambda () (interactive)
                               (term-send-raw-string "\t")))
                    ("<escape>" . (lambda () (interactive)
                                    (term-send-raw-string "")))))
            ))

;;; ============================== misc ==================================
;;; shotcuts key
(global-set-key (kbd "<f2>") 'eshell)
(global-set-key (kbd "<f3>") 'hong/shell-run)
(global-set-key (kbd "M-[") 'multi-term-prev)
(global-set-key (kbd "M-]") 'multi-term-next)
(defalias 'sh 'shell)
(defalias 'mt 'multi-term)
(defalias 'mtdo 'multi-term-dedicated-open)

(defun hong/switch-non-terminal-buffer ()
  "switch first no terminal buffer.
   use buffer list"
  (interactive)
  (let* ((buffer-list (mapcar (lambda (buf) (buffer-name buf)) (buffer-list)))
         (ignore-buffers
          (concat
           "^\\*term\\|^\\*eshell\\|^\\*shell\\|"
           "^ ?\\*Minibuf\\|^ ?\\*code.*work\\*$\\|^\\*Message\\|"
           "^ ?\\*Echo\\|^\\*\\([0-9]\\{1,3\\}.\\)\\{3\\}[0-9]\\{1,3\\}\\*$"))
         (last-noterm-buffer
          (catch 'ret
            (mapcar (lambda (str)
                      (if (not (string-match ignore-buffers str))
                          (throw 'ret str)))
                    buffer-list))))
    (and last-noterm-buffer (switch-to-buffer last-noterm-buffer))))

(defun clear-before-line ()
  (interactive)
  (let ((start (previous-char-property-change (point)))
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
