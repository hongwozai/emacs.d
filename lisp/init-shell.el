;;; shell-script-mode
(push '("\\.zsh\\'" . sh-mode) auto-mode-alist)
(push '("\\.sh\\'" . sh-mode) auto-mode-alist)
(push '("\\.bash\\'" . sh-mode) auto-mode-alist)
(push '("\\.bashrc\\'" . sh-mode) auto-mode-alist)
(push '("\\.bash_history\\'" . sh-mode) auto-mode-alist)
(push '("\\.bash_profile\\'" . sh-mode) auto-mode-alist)

;;; set path
(require-package 'exec-path-from-shell)
(exec-path-from-shell-initialize)

;;; ========================== eshell =================================
(add-hook 'eshell-mode-hook
          (lambda ()
            (define-key eshell-mode-map (kbd "C-p")
              'eshell-previous-matching-input-from-input)
            (define-key eshell-mode-map (kbd "C-n")
              'eshell-next-matching-input-from-input)
            (define-key eshell-mode-map (kbd "C-t")
              'hong/switch-non-terminal-buffer)

            (setq pcomplete-cycle-completions nil
                  eshell-cmpl-cycle-completions nil
                  eshell-save-history-on-exit nil
                  eshell-buffer-shorthand t)

            (setq-local show-trailing-whitespace nil)
            (setq-local mode-require-final-newline nil)
            (mapc (lambda (x) (push x eshell-visual-commands))
                  '("ssh" "htop" "less" "tmux" "top" "vim"))

            ;; auto end
            (defun hong//eshell-auto-end ()
              (when (and (eq major-mode 'eshell-mode)
                         (not (eq (line-end-position) (point-max))))
                (end-of-buffer)))
            (add-hook 'evil-insert-state-entry-hook
                      'hong//eshell-auto-end nil t)

            ;; eshell clear
            (defun eshell/clear ()
              (interactive)
              (let ((inhibit-read-only t))
                (erase-buffer)))

            ;; company
            (defun hong//toggle-eshell-directory ()
              (if (file-remote-p default-directory)
                  (setq-local company-idle-delay nil)
                (setq-local company-idle-delay 0.5)))
            (add-hook 'eshell-directory-change-hook
                      'hong//toggle-eshell-directory)
            (setq-local company-backends '(company-capf))
            (defalias 'ff #'find-file)))

;;; ============================= shell comint =============================
;;; bash completion in shell mode
(require-package 'bash-completion)
(autoload 'bash-completion-dynamic-complete "bash-completion" "BASH complete" )

;;; shell
(setq shell-file-name "/bin/bash")
(setq explicit-shell-file-name "/bin/bash")
(add-hook 'shell-mode-hook 'hong/exit)
(add-hook 'shell-mode-hook
          (lambda ()
            (setq-local mode-require-final-newline nil)
            (define-key shell-mode-map (kbd "C-t") 'hong/switch-non-terminal-buffer)
            (define-key shell-mode-map (kbd "C-p") 'comint-previous-input)
            (define-key shell-mode-map (kbd "C-n") 'comint-next-input)))

;;; comint mode
(add-hook 'comint-mode-hook
          (lambda ()
            (define-key comint-mode-map (kbd "C-c C-r") 'hong/clear-shell)
            (define-key comint-mode-map (kbd "C-t") 'hong/switch-non-terminal-buffer)
            (define-key comint-mode-map (kbd "C-p") 'comint-previous-input)
            (define-key comint-mode-map (kbd "C-n") 'comint-next-input)
            (setq-local mode-require-final-newline nil)
            (setq-local comint-history-isearch t)))

;;; ============================= term =====================================
(require-package 'multi-term)
(setq multi-term-program "/bin/bash")
;;; term-mode-hook term-raw-map !!! must be term-raw-map
(global-set-key (kbd "M-[") 'multi-term-prev)
(global-set-key (kbd "M-]") 'multi-term-next)
(add-hook 'term-mode-hook
          (lambda ()
            (setq-local evil-move-cursor-back nil)
            (setq-local evil-escape-inhibit t)
            (setq-local mode-require-final-newline nil)
            (evil-define-key 'normal term-raw-map "p" 'term-paste)
            (setq multi-term-switch-after-close nil)
            (setq multi-term-dedicated-select-after-open-p t)
            (setq term-buffer-maximum-size 0)
            (setq multi-term-scroll-to-bottom-on-output 'all)
            (setq-local show-trailing-whitespace nil)
            (setq term-unbind-key-list '("C-x"))
            (setq term-bind-key-alist
                  '(("C-r" . term-send-reverse-search-history)
                    ("C-t" . hong/switch-non-terminal-buffer)
                    ("M-:" . eval-expression)
                    ("C-d" . term-send-eof)
                    ("C-y" . term-paste)
                    ("M-y" . yank-pop)
                    ("C-p" . term-send-up)
                    ("C-n" . term-send-down)
                    ("M-DEL" . term-send-backward-kill-word)
                    ("M-d" . term-send-forward-kill-word)
                    ("M-c" . term-send-raw-meta)
                    ("M-f" . term-send-forward-word)
                    ("M-b" . term-send-backward-word)
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
(defalias 'sh 'shell)
(defalias 'mt 'multi-term)
(defalias 'mtdo 'multi-term-dedicated-open)

(defun hong//list-find-ret (list func)
  (cond ((funcall func (car list)) (car list))
        ((null (cdr list)) nil)
        (t (hong//list-find-ret (cdr list) func))))

(defun hong/switch-non-terminal-buffer ()
  "switch first no terminal buffer.
   use ido's ido-buffer-history"
  (interactive)
  (let* ((buffer-list (mapcar (lambda (buf) (buffer-name buf)) (buffer-list)))
         (last-noterm-buffer
          (hong//list-find-ret
           buffer-list
           (lambda (str)
             (not (string-match
                   (concat "^\\*terminal\\|^\\*eshell\\|^\\*shell\\|"
                           "^ ?\\*Minibuf\\|^ ?\\*code.*work\\*$\\|^\\*Message\\|"
                           "^ ?\\*Echo")
                   str))))))
    (and last-noterm-buffer (switch-to-buffer last-noterm-buffer))
    ))

(defun hong/clear-shell ()
  (interactive)
  (erase-buffer)
  (comint-send-input))

(provide 'init-shell)
