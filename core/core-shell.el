;;-------------------------------------------
;;; shell common
;;-------------------------------------------
(defun core--goto-max-with-emacs-state ()
  (interactive)
  (goto-char (point-max))
  (evil-emacs-state))

(defun core--set-work-state ()
  "ESC -> normal state; i/a/s.. -> emacs state"
  (shell-header-mode)
  (evil-set-initial-state major-mode 'emacs)
  (dolist (key '("i" "I" "a" "A" "s" "S" "c" "C"))
    (evil-local-set-key
     'normal key 'core--goto-max-with-emacs-state)))

;;-------------------------------------------
;;; eshell
;;-------------------------------------------
(defalias 'esh       #'multi-eshell)
(defalias 'eshell/e  #'find-file)
(defalias 'eshell/em #'find-file)
(defalias 'eshell/fo #'find-file-other-window)
(defalias 'eshell/d  #'dired)
(defalias 'eshell/do #'dired-other-window)

(add-hook 'eshell-load-hook
          (lambda ()
            (setq eshell-save-history-on-exit nil
                  eshell-buffer-shorthand     t
                  eshell-hist-ignoredups      t)))

(add-hook 'eshell-mode-hook
          (lambda ()
            (core/set-key eshell-mode-map
              :state 'emacs
              (kbd "C-r") 'counsel-esh-history
              (kbd "C-n") 'eshell-next-matching-input-from-input
              (kbd "C-p") 'eshell-previous-matching-input-from-input
              (kbd "C-u") 'eshell-kill-input
              (kbd "TAB") 'completion-at-point)

            ;; replace builtin clear
            (defun eshell/clear ()
              (interactive)
              (eshell/clear-scrollback))

            (core--set-work-state)))

;;; use eshell
(defun multi-eshell ()
  (interactive)
  (eshell t))

(defun eshell/b (&optional buffer)
  (interactive)
  (if buffer (switch-to-buffer buffer) (ibuffer)))

(defun eshell/bo (&optional buffer)
  (interactive)
  (if buffer (switch-to-buffer-other-window buffer) (ibuffer)))

;;-------------------------------------------
;;; comint
;;-------------------------------------------
(add-hook 'comint-mode-hook
          (lambda ()
            (core/auto-exit)
            (setq-local comint-prompt-read-only t)
            (setq-local comint-move-point-for-output 'others)
            (setq-local comint-history-isearch t)
            (core/set-key comint-mode-map
              :state 'emacs
              (kbd "C-n")    'comint-next-input
              (kbd "C-p")    'comint-previous-input
              (kbd "<up>")   'comint-next-input
              (kbd "<down>") 'comint-previous-input)
            (core--set-work-state)))

;;-------------------------------------------
;;; multi-term
;;-------------------------------------------
(require-package 'multi-term)

(setq multi-term-program "/bin/bash")

(defalias 'mt 'multi-term)
(autoload 'multi-term-prev "multi-term" nil t)
(autoload 'multi-term-next "multi-term" nil t)
(autoload 'multi-term      "multi-term" nil t)

;;-------------------------------------------
;;; term config
;;-------------------------------------------
(add-hook 'term-mode-hook
          (lambda ()
            ;; compatiable
            (setq-local evil-move-cursor-back nil)
            (setq-local evil-escape-inhibit t)
            ;; term
            (setq multi-term-switch-after-close nil)
            (setq multi-term-dedicated-select-after-open-p t)
            (setq multi-term-scroll-to-bottom-on-output 'others)
            (setq term-buffer-maximum-size 5000)
            ;; multi-term keybinding
            (term-set-escape-char ?\C-c)
            (setq term-unbind-key-list '("C-x"))
            (setq term-bind-key-alist
                  '(("C-f" . counsel-find-file)
                    ("C-y" . term-paste)
                    ("M-:" . eval-expression)
                    ("<C-backspace>" . term-send-raw-meta)
                    ("M-d" . term-send-forward-kill-word)
                    ("M-x" . execute-extended-command)
                    ("M-]" . shell-header-next)
                    ("M-[" . shell-header-prev)
                    ("TAB" . (lambda () (interactive)
                               (term-send-raw-string "\t")))
                    ("<escape>" . (lambda () (interactive)
                                    (term-send-raw-string "")))))
            (core--set-work-state)))

;;-------------------------------------------
;;; shell header line
;;-------------------------------------------
;;; autoload
(autoload 'shell-header-mode "shell-header-mode" nil t)
(autoload 'shell-header-next "shell-header-mode" nil t)
(autoload 'shell-header-prev "shell-header-mode" nil t)

(provide 'core-shell)
