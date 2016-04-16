;;; shell-script-mode
(push '("\\.*rc\\'" . sh-mode) auto-mode-alist)
(push '("\\.zsh\\'" . sh-mode) auto-mode-alist)
(push '("\\.sh\\'" . sh-mode) auto-mode-alist)
(push '("\\.bash\\'" . sh-mode) auto-mode-alist)
(push '("\\.bashrc\\'" . sh-mode) auto-mode-alist)
(push '("\\.bash_history\\'" . sh-mode) auto-mode-alist)
(push '("\\.bash_profile\\'" . sh-mode) auto-mode-alist)

;;; set path
(require-package 'exec-path-from-shell)
(setq exec-path-from-shell-check-startup-files nil)
(exec-path-from-shell-initialize)

;;; ========================== eshell =================================
(add-hook 'eshell-mode-hook
          (lambda ()
            (define-key eshell-mode-map (kbd "C-p") 'eshell-previous-matching-input-from-input)
            (define-key eshell-mode-map (kbd "C-n") 'eshell-next-matching-input-from-input)
            (define-key eshell-mode-map (kbd "M-,") 'hong/switch-non-terminal-buffer)
            (define-key eshell-mode-map (kbd "C-u") 'hong/clear-before-line)
            (define-key eshell-mode-map [remap eshell-pcomplete] 'completion-at-point)

            (setq pcomplete-cycle-completions nil
                  eshell-cmpl-cycle-completions nil
                  eshell-save-history-on-exit nil
                  eshell-buffer-shorthand t)

            (setq-local show-trailing-whitespace nil)
            (setq-local mode-require-final-newline nil)
            (mapc (lambda (x) (push x eshell-visual-commands))
                  '("ssh" "htop" "less" "tmux" "top" "vim"))

            ;; history
            (defun hong/eshell-find-history ()
              (interactive)
              (insert (ivy-read
                       "Eshell history: "
                       (delete-dups
                        (ring-elements eshell-history-ring)))))
            (define-key eshell-mode-map (kbd "C-s") 'hong/eshell-find-history)

            ;; eshell clear
            (defun eshell/clear ()
              (interactive)
              (let ((inhibit-read-only t))
                (erase-buffer)))

            ;; company
            (setq-local company-backends nil)
            (defalias 'em #'find-file)
            (defalias 'd #'dired)
            ))

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
            (define-key comint-mode-map (kbd "C-l") 'hong/clear-shell)
            (define-key comint-mode-map (kbd "M-,") 'hong/switch-non-terminal-buffer)
            (define-key comint-mode-map (kbd "C-p") 'comint-previous-input)
            (define-key comint-mode-map (kbd "C-n") 'comint-next-input)
            (define-key comint-mode-map (kbd "C-u") 'hong/clear-before-line)
            (define-key comint-mode-map (kbd "<up>") 'comint-previous-input)
            (define-key comint-mode-map (kbd "<down>") 'comint-next-input)
            (setq-local comint-prompt-read-only t)
            (setq-local mode-require-final-newline nil)
            (setq-local comint-move-point-for-output 'others)
            (setq-local comint-history-isearch t)))

;;; ============================= term =====================================
(setq multi-term-program "/bin/bash")
;;; term-mode-hook term-raw-map !!! must be term-raw-map
(add-hook 'term-mode-hook
          (lambda ()
            ;; compatiable
            (setq-local evil-move-cursor-back nil)
            (setq-local evil-escape-inhibit t)
            (setq-local mode-require-final-newline nil)
            (setq-local show-trailing-whitespace nil)
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
         (last-noterm-buffer
          (catch 'ret
            (mapcar (lambda (str)
                      (if (not (string-match
                                (concat
                                 "^\\*term\\|^\\*eshell\\|^\\*shell\\|"
                                 "^ ?\\*Minibuf\\|^ ?\\*code.*work\\*$\\|^\\*Message\\|"
                                 "^ ?\\*Echo\\|^\\*\\([0-9]\\{1,3\\}.\\)\\{3\\}[0-9]\\{1,3\\}\\*$")
                                str))
                          (throw 'ret str)))
                    buffer-list))))
    (and last-noterm-buffer (switch-to-buffer last-noterm-buffer))))

(defun hong/clear-before-line ()
  (interactive)
  (let ((start (line-beginning-position))
        (end (point)))
    (delete-region start end)))

(defun hong/clear-shell ()
  (interactive)
  (let ((inhibit-read-only t))
    (unless (eq (line-number-at-pos) 1)
      (forward-line -1)
      (delete-region (point-min) (1+ (line-end-position)))))
  (goto-char (point-max)))

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
         (setq command (match-string 1 command))
         (display-buffer (funcall #'find-file-noselect command)))
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
