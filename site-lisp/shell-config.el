;;-------------------------------------------
;;; auto exit from shell, term, comint
;;-------------------------------------------
(defun core--exit-prompt (process state)
  (if (string-match "\\(exited\\|finished\\)" state)
      (progn
        (quit-window)
        (kill-buffer (process-buffer process)))))

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

(defun core/auto-exit ()
  (let ((process
         (ignore-errors
           (get-buffer-process (current-buffer)))))
    (when process
      (set-process-sentinel process 'core--exit-prompt))))

;;; autoload shell-header
(autoload 'shell-header-mode "shell-header-mode" nil t)
(autoload 'shell-header-next "shell-header-mode" nil t)
(autoload 'shell-header-prev "shell-header-mode" nil t)
;;-------------------------------------------
;;; comint
;;-------------------------------------------
(add-hook 'comint-mode-hook
          (lambda ()
            (core/auto-exit)
            (setq-local comint-prompt-read-only t)
            (setq-local comint-move-point-for-output 'others)
            (setq-local comint-history-isearch t)
            (define-key comint-mode-map (kbd "C-n") 'comint-next-input)
            (define-key comint-mode-map (kbd "C-p") 'comint-previous-input)
            (define-key comint-mode-map (kbd "<up>") 'comint-next-input)
            (define-key comint-mode-map (kbd "<down>") 'comint-previous-input)
            (define-key comint-mode-map (kbd "C-l") 'comint-clear-buffer)
            (define-key comint-mode-map (kbd "C-u") 'comint-kill-input)
            (define-key comint-mode-map (kbd "C-w C-w") 'evil-window-next)
            (core--set-work-state)))

;;; comint color
(setq comint-output-filter-functions
      (remove 'ansi-color-process-output comint-output-filter-functions))

;;-------------------------------------------
;;; eshell
;;-------------------------------------------
(defalias 'esh #'multi-eshell)

(add-hook 'eshell-load-hook
          (lambda ()
            (setq eshell-save-history-on-exit nil
                  eshell-buffer-shorthand     t
                  eshell-hist-ignoredups      t)))

(add-hook 'eshell-mode-hook
          (lambda () (core--set-work-state)))

(with-eval-after-load 'esh-mode
  (define-key eshell-mode-map (kbd "C-r") 'eshell-isearch-backward)
  (define-key eshell-mode-map (kbd "C-n") 'eshell-next-matching-input-from-input)
  (define-key eshell-mode-map (kbd "C-p") 'eshell-previous-matching-input-from-input)
  (define-key eshell-mode-map (kbd "C-u") 'eshell-kill-input)
  (define-key eshell-mode-map (kbd "C-l") 'eshell/clear)
  (define-key eshell-mode-map (kbd "<C-backspace>") 'eshell-backward-kill-word)
  (define-key eshell-mode-map (kbd "M-DEL") 'eshell-backward-kill-word)
  (define-key eshell-mode-map (kbd "DEL")   'eshell-delete-backward-char)
  (define-key eshell-mode-map (kbd "M-o") 'other-window)

  ;; repace clear function
  (defun eshell/clear ()
    (interactive)
    (eshell/clear-scrollback)))

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
     (if (< end backward) backward end))))

(defun eshell-delete-backward-char ()
  (interactive)
  (let ((end (marker-position eshell-last-output-end))
        (backward (save-excursion (forward-char -1) (point))))
    (kill-region
     (point)
     (if (< end backward) backward end))))

;;-------------------------------------------
;;; term
;;-------------------------------------------
;; term
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
                    ("M-w" . kill-ring-save)
                    ("M-o" . other-window)
                    ("TAB" . (lambda () (interactive)
                               (term-send-raw-string "\t")))
                    ("<escape>" . (lambda () (interactive)
                                    (term-send-raw-string "")))))
            (core--set-work-state)))

;; multi term
(use-package multi-term :ensure t :defer t
  :init
  (if *is-mac*
      (setq multi-term-program "/bin/zsh")
    (setq multi-term-program "/bin/bash"))
  (defalias 'mt 'multi-term))

;;-------------------------------------------
;;; vterm
;;-------------------------------------------
(use-package vterm :ensure t :defer t
  :init
  (evil-set-initial-state 'vterm-mode 'emacs)
  (defalias 'vt 'vterm)
  (add-hook 'vterm-mode-hook
            (lambda ()
              (shell-header-mode)
              (define-key vterm-mode-map (kbd "C-u") 'vterm--self-insert)
              (define-key vterm-mode-map (kbd "M-o") 'other-window)
              (core/auto-exit)
              (local-set-key [escape] 'vterm--self-insert))))

;;-------------------------------------------
;;; powershell
;;-------------------------------------------
(use-package powershell
  :if (eq system-type 'windows-nt)
  :ensure t
  :defer t)


(provide 'shell-config)