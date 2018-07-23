;;-------------------------------------------
;;; basic option
;;-------------------------------------------
(setq debug-on-error nil)
(setq debug-on-quit nil)
(setq ad-redefinition-action 'accept)
(setq enable-local-variables :all enable-local-eval t)

(fset 'yes-or-no-p 'y-or-n-p)

;;; evironment
(prefer-coding-system 'utf-8)
(set-language-environment "utf-8")
(set-default-coding-systems 'utf-8)

;;-------------------------------------------
;;; basic edit options
;;-------------------------------------------
(setq-default default-tab-width           4
              indent-tabs-mode            nil
              column-number-mode          t
              scroll-preserve-screen-position 'always
              make-backup-files           nil
              auto-save-mode              nil
              x-select-enable-clipboard   t
              mouse-yank-at-point         t
              truncate-lines              nil
              scroll-margin               0
              scroll-step                 5
              visible-bell                t
              mode-require-final-newline  nil
              split-width-threshold       90
              ring-bell-function          'ignore)

;;-------------------------------------------
;;; basic mode
;;-------------------------------------------
;;; cursor
(blink-cursor-mode 0)

;;; syntax hightlight
(global-font-lock-mode t)

;; Auto refresh buffers, dired revert have bugs.
;;; remote file revert have bugs.
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t
      dired-auto-revert-buffer            nil
      auto-revert-verbose                 nil)

;; uniquify buffer-name
(require 'uniquify)

;;; ediff
(setq ediff-split-window-function 'split-window-horizontally)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;;; minibuffer
(setq minibuffer-message-timeout 2)

;;; linum-mode
(setq linum-format " %3d ")

;;-------------------------------------------
;;; recent files
;;-------------------------------------------
(setq recentf-auto-cleanup 'never)
(setq recentf-filename-handlers 'abbreviate-file-name)
(require 'recentf)
(setq recentf-max-saved-items 100)
(setq recentf-exclude '(".*\\.png$" ".*\\.gz$" ".*\\.jpg$"
                        "GTAGS" "TAGS" "^tags$" ".*pyim.*"))

;;; load
(add-hook 'after-init-hook #'recentf-mode)

;;-------------------------------------------
;;; auto-save(dont't use emacs builtin)
;;-------------------------------------------
(setq-default auto-save-default nil)
(require 'auto-save-simple-mode)
(auto-save-simple-mode t)

;;-------------------------------------------
;;; pair
;;-------------------------------------------
;;; show
(show-paren-mode t)
(setq show-paren-style 'parenthesis)

;; input
(when (fboundp 'electric-pair-mode)
  (electric-pair-mode t))

;;-------------------------------------------
;;; grep
;;-------------------------------------------
(setq-default grep-hightlight-matches     t
              grep-scroll-output          nil
              grep-use-null-device        nil)

(setq grep-command
      (cond ((executable-find "rg") "rg --no-heading -w ")
            ((executable-find "ag") "ag --nogroup --noheading ")
            (t "grep --binary-files=without-match -nH -r -E -e ")))

(defun grep-read-files! (orig-fun &rest args)
  (let ((completing-read-function 'completing-read-default))
    (apply orig-fun args)))

(advice-add 'grep-read-files :around #'grep-read-files!)

;; multi files modify wgrep
(require-package 'wgrep)
(setq wgrep-enable-key "r")

;;-------------------------------------------
;;; compilation
;;-------------------------------------------
(setq compile-command "make")
;;; C-u -> read command and interactive
(setq compilation-read-command t)
;; (setq compilation-auto-jump-to-first-error t)
(setq compilation-window-height 14)
(setq compilation-scroll-output t)
(setq compilation-finish-function nil)

;;-------------------------------------------
;;; highlight
;;-------------------------------------------
(defun highlight-symbol ()
  (interactive)
  (require 'hi-lock nil t)
  (let ((regexp
         (hi-lock-regexp-okay
          (if (use-region-p)
              ;; region
              (regexp-quote
               (buffer-substring-no-properties
                (region-beginning) (region-end)))
            ;; symbol
            (find-tag-default-as-symbol-regexp)))))
    (if (assoc regexp hi-lock-interactive-patterns)
        (unhighlight-regexp regexp)
      (if (not (use-region-p))
          (highlight-symbol-at-point)
        (deactivate-mark)
        (let* ((hi-lock-auto-select-face t)
               (face (hi-lock-read-face-name)))
          (or (facep face) (setq face 'hi-yellow))
          (hi-lock-face-buffer regexp face))))))

(defun unhighlight-all-symbol ()
  (interactive)
  (unhighlight-regexp t))

;;-------------------------------------------
;;; programming mode
;;-------------------------------------------
(add-hook 'prog-mode-hook
          (lambda ()
            ;; trailing whitespace
            (setq-local show-trailing-whitespace t)
            ;; fold
            (hs-minor-mode t)
            ;;; pretty symbol
            (prettify-symbols-mode t)
            ))

(provide 'core-options)
