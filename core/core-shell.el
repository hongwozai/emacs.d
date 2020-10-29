;;-------------------------------------------
;;; shell common
;;-------------------------------------------
;;; instead of ansi-color
(require 'xterm-color)

;;; common functions
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
     'normal key 'core--goto-max-with-emacs-state))
  ;; for graphic
  (local-set-key [escape] 'evil-normal-state))

;;-------------------------------------------
;;; eshell
;;-------------------------------------------
(defalias 'esh       #'multi-eshell)
(defalias 'eshell/e  #'find-file)
(defalias 'eshell/em #'find-file)
(defalias 'eshell/fo #'find-file-other-window)
(defalias 'eshell/vi #'find-file)
(defalias 'eshell/vim #'find-file)
(defalias 'eshell/d  #'dired)
(defalias 'eshell/do #'dired-other-window)
(defalias 'eshell/fr #'counsel-recentf)

;;; eshell term color
(add-hook 'eshell-before-prompt-hook
          (lambda ()
            (setq xterm-color-preserve-properties t)))

(add-hook 'eshell-load-hook
          (lambda ()
            (setq eshell-save-history-on-exit nil
                  eshell-buffer-shorthand     t
                  eshell-hist-ignoredups      t)))

(add-hook 'eshell-mode-hook
          (lambda ()
            (core/set-key eshell-mode-map
              :state 'emacs
              (kbd "C-r")   'counsel-esh-history
              (kbd "C-n")   'eshell-next-matching-input-from-input
              (kbd "C-p")   'eshell-previous-matching-input-from-input
              (kbd "C-u")   'eshell-kill-input
              (kbd "C-l")   'eshell/clear
              (kbd "<tab>") 'completion-at-point
              (kbd "TAB")   'completion-at-point
              (kbd "<C-backspace>") 'eshell-backward-kill-word
              (kbd "M-DEL") 'eshell-backward-kill-word
              (kbd "DEL")   'eshell-delete-backward-char)

            ;; replace builtin clear
            (defun eshell/clear ()
              (interactive)
              (eshell/clear-scrollback))

            (core--set-work-state)))

;; eshell color
(add-hook 'eshell-mode-hook
          (lambda ()
            (setenv "TERM" "xterm-256color")
            (add-to-list 'eshell-preoutput-filter-functions 'xterm-color-filter)
            (setq eshell-output-filter-functions
                  (remove 'eshell-handle-ansi-color eshell-output-filter-functions))
            ))

;;; use eshell
(defun multi-eshell ()
  (interactive)
  (eshell t))

(defun eshell-backward-kill-word (arg)
  (interactive "p")
  (let ((end (marker-position eshell-last-output-end))
        (backward (save-excursion (forward-word (- arg)) (point))))
    (kill-region
     (point)
     (if (< end backward) backward end))
    ))

(defun eshell-delete-backward-char ()
  (interactive)
  (let ((end (marker-position eshell-last-output-end))
        (backward (save-excursion (forward-char -1) (point))))
    (kill-region
     (point)
     (if (< end backward) backward end))))

(defun eshell/b (&optional buffer)
  (interactive)
  (if buffer
      (switch-to-buffer buffer)
    (ivy-switch-buffer)))

(defun eshell/bo (&optional buffer)
  (interactive)
  (if buffer
      (switch-to-buffer-other-window buffer)
    (ivy-switch-buffer-other-window)))

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
              (kbd "<down>") 'comint-previous-input
              (kbd "C-l")    'comint-clear-buffer
              (kbd "C-u")    'comint-kill-input)
            (core--set-work-state)))

;;; comint color
(setq comint-output-filter-functions
      (remove 'ansi-color-process-output comint-output-filter-functions))

(add-hook 'shell-mode-hook
          (lambda ()
            (add-hook 'comint-preoutput-filter-functions
                      'xterm-color-filter nil t)))
;;-------------------------------------------
;;; multi-term
;;-------------------------------------------
(require-package 'multi-term)

(if *is-mac*
    (setq multi-term-program "/bin/zsh")
  (setq multi-term-program "/bin/bash"))

(defalias 'mt 'multi-term)
(autoload 'multi-term-prev "multi-term" nil t)
(autoload 'multi-term-next "multi-term" nil t)
(autoload 'multi-term      "multi-term" nil t)

;;-------------------------------------------
;;; term config
;;-------------------------------------------
(add-hook 'term-mode-hook
          (lambda ()
            ;; don't use xterm-256color, display abnormal
            (set (make-local-variable 'term-term-name)
                 "eterm-color")
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
                  '(("C-y" . term-paste)
                    ("M-:" . eval-expression)
                    ("<C-backspace>" . term-send-raw-meta)
                    ("M-d" . term-send-forward-kill-word)
                    ("M-x" . execute-extended-command)
                    ("M-]" . shell-header-next)
                    ("M-[" . shell-header-prev)
                    ("M-i" . ivy-switch-buffer)
                    ("M-o" . hydra-window/body)
                    ("TAB" . (lambda () (interactive)
                               (term-send-raw-string "\t")))
                    ("<escape>" . (lambda () (interactive)
                                    (term-send-raw-string "")))))
            (core--set-work-state)))

;;-------------------------------------------
;;; compilation
;;-------------------------------------------
(setq compilation-environment '("TERM=xterm-256color"))

(add-hook 'compilation-start-hook
          (lambda (proc)
            ;; We need to differentiate between compilation-mode buffers
            ;; and running as part of comint (which at this point we assume
            ;; has been configured separately for xterm-color)
            (when (eq (process-filter proc) 'compilation-filter)
              ;; This is a process associated with a compilation-mode buffer.
              ;; We may call `xterm-color-filter' before its own filter function.
              (set-process-filter
               proc
               (lambda (proc string)
                 (funcall 'compilation-filter proc
                          (xterm-color-filter string)))))))

;;-------------------------------------------
;;; shell header line
;;-------------------------------------------
;;; autoload
(autoload 'shell-header-mode "shell-header-mode" nil t)
(autoload 'shell-header-next "shell-header-mode" nil t)
(autoload 'shell-header-prev "shell-header-mode" nil t)

(provide 'core-shell)
