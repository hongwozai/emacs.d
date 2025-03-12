;;; -*- coding: utf-8 -*-

;;-------------------------------------------
;;; custom ui
;;-------------------------------------------
(defun set-graphic-font (dfl ch)
  (when (display-graphic-p)
    (set-face-attribute 'default nil
                        :font (format "%s %d" (car dfl) (cdr dfl)))
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font (frame-parameter nil 'font) charset
                        (font-spec :family (car ch)  :size (cdr ch))))))

(when *is-mac*
  (set-face-attribute 'default nil :font "Menlo 18")
  (setq mac-option-modifier 'meta))

(when (eql system-type 'gnu/linux)
  (set-face-attribute 'default nil :font "DejaVu Sans Mono Bold 16"))

(when (eq system-type 'windows-nt)
  (set-graphic-font '("DejaVu Sans Mono Bold" . 16)
                    '("微软雅黑" . 20)))

;; startup message
(setq use-file-dialog nil)
(setq use-dialog-box nil)
(setq inhibit-startup-message t)
(setq inhibit-default-init t)

;; disable any bar
(when (boundp 'tool-bar-mode)
  (tool-bar-mode -1))

(when (boundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

(when (boundp 'menu-bar-mode)
  (menu-bar-mode -1))

;; modeline
(setq-default mode-line-format
              '("%e"
                " "
                (:eval (when (featurep 'winum-mode)
                         (winum-get-number-string)))
                mode-line-front-space
                mode-line-mule-info
                mode-line-client
                mode-line-modified
                mode-line-remote
                ;; vim state
                (:eval (when (featurep 'evil) evil-mode-line-tag))
                ;; line and column
                "[" "%02l" "," "%01c" "] "
                mode-line-frame-identification
                mode-line-buffer-identification
                (vc-mode vc-mode)
                "  "
                mode-line-modes
                mode-line-misc-info
                mode-line-end-spaces))

;; theme
(load-theme 'leuven t)

;;-------------------------------------------
;;; basic option
;;-------------------------------------------
(setq debug-on-error nil)
(setq debug-on-quit nil)
(setq ad-redefinition-action 'accept)
(setq enable-local-variables :all enable-local-eval t)
(fset 'yes-or-no-p 'y-or-n-p)

;;; evironment
(set-language-environment "utf-8")
(set-default-coding-systems 'utf-8)
(setq save-buffer-coding-system 'utf-8)

;;; edit
(setq-default tab-width                   4
              default-tab-width           4
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
              split-width-threshold       nil
              ring-bell-function          'ignore)

;; uniquify buffer-name
(require 'uniquify)

;;; minibuffer
(setq minibuffer-message-timeout 2)

(define-key minibuffer-mode-map (kbd "M-i")
            (lambda () (interactive)
              (let ((sym (with-selected-window (minibuffer-selected-window)
                           (symbol-at-point))))
                (with-current-buffer (current-buffer)
                  (insert (format "%s" (or sym "")))))))


;; Auto refresh buffers, dired revert have bugs.
;;; remote file revert have bugs.
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t
      dired-auto-revert-buffer            nil
      auto-revert-verbose                 nil)

;;; recent files
(require 'recentf)
(setq recentf-filename-handlers 'abbreviate-file-name)
(setq recentf-max-saved-items 100)
(setq recentf-exclude '(".*\\.png$" ".*\\.gz$" ".*\\.jpg$"
                        "GTAGS" "TAGS" "^tags$" ".*pyim.*"))
(add-hook 'after-init-hook #'recentf-mode)

;;; cursor
(blink-cursor-mode 0)

;;; syntax hightlight
(global-font-lock-mode t)

;;; show pair
(show-paren-mode t)
(setq show-paren-style 'parenthesis)

;;; grep
(setq-default grep-hightlight-matches     t
              grep-scroll-output          nil
              grep-use-null-device        nil)

(defun core--grep ()
  (interactive)
  (let ((command
         (cond ((locate-dominating-file default-directory ".git") "git grep -n ")
               ((executable-find "rg") "rg -n --no-heading -w ")
               ((executable-find "ag") "ag --nogroup --noheading ")
               (t "grep --binary-files=without-match -nH -r -E -e "))))
    (grep-apply-setting 'grep-command command)
    (call-interactively #'grep)))

(global-set-key (kbd "C-s") 'core--grep)

;;-------------------------------------------
;;; tramp
;;-------------------------------------------
;;; ssh is faster than scp. scpx or sshx. see Tramp hangs
(setq tramp-default-method "ssh")
(setq tramp-verbose 2)
(setq tramp-connection-timeout 20)

;;; save password(2 hours)
(setq password-cache t)
(setq password-cache-expiry 7200)

;;; faster see wiki Tramp hangs #2
(setq tramp-chunksize 8192)
(setq tramp-ssh-controlmaster-options
      "-o ControlMaster=auto -o ControlPath='tramp.%%C' -o ControlPersist=no")

;;; experiment
(setq enable-remote-dir-locals t)

;;-------------------------------------------
;;; dired
;;-------------------------------------------
(with-eval-after-load 'dired
  ;; diredp
  (setq dired-recursive-copies   'always)
  (setq dired-recursive-deletes  'always)
  (setq dired-isearch-filenames  t)
  (setq dired-dwim-target        t)
  (if *is-mac*
      (setq dired-listing-switches "-aluh")
    (setq dired-listing-switches "-aluh --time-style=iso"))

  ;; key
  (define-key dired-mode-map (kbd "M-o") 'dired-omit-mode)
  (define-key dired-mode-map [mouse-2] 'dired-find-file)
  (define-key dired-mode-map "n" 'evil-search-next)
  (define-key dired-mode-map "N" 'evil-search-previous)
  )

(add-hook 'dired-mode-hook
          (lambda ()
            (require 'dired-x)
            (setq-local truncate-lines t)
            (setq-local dired-omit-files
                        "^\\.?#\\|^\\.$\\|^\\.[^.].+$")
            (setq dired-omit-verbose nil)
            (dired-omit-mode)
            (dired-hide-details-mode 1)
            (hl-line-mode 1)
            (define-key dired-mode-map "F" 'ffip)))

;;-------------------------------------------
;;; buffer
;;-------------------------------------------
(global-set-key (kbd "C-x k") 'kill-this-buffer)

(with-eval-after-load 'ibuffer
  (require 'ibuf-ext)
  ;; (add-to-list 'ibuffer-never-show-predicates "^\\*")
  (setq ibuffer-show-empty-filter-groups nil)
  (add-hook 'ibuffer-hook
            (lambda ()
              (ibuffer-switch-to-saved-filter-groups "default")
              (ibuffer-update nil t)
              (hl-line-mode 1))))

;;; windows
(winner-mode t)

;;-------------------------------------------
;;; search
;;-------------------------------------------
(defun core--isearch-insert (query)
  "Pull next word from buffer into search string."
  (interactive)
  (setq isearch-message (concat isearch-message query))
  (setq isearch-string (concat isearch-string query))
  (isearch-push-state)
  (isearch-update))

(define-key isearch-mode-map (kbd "M-o") 'isearch-occur)
(define-key isearch-mode-map (kbd "SPC")
            (lambda () (interactive) (core--isearch-insert ".*?")))
(define-key isearch-mode-map (kbd "M-i")
            (lambda () (interactive)
              (core--isearch-insert
               (with-current-buffer (current-buffer)
                 (format "%s" (symbol-at-point))))))

;;-------------------------------------------
;;; highlight
;;-------------------------------------------
(defun core--highlight-symbol ()
  (interactive)
  (require 'hi-lock)
  (let ((regexp (find-tag-default-as-symbol-regexp)))
    (if (assoc regexp hi-lock-interactive-lighters)
        (unhighlight-regexp regexp)
      (highlight-symbol-at-point))))

(defun core--unhighlight-all-symbol ()
  (interactive)
  (unhighlight-regexp t))

;;-------------------------------------------
;;; interactive
;;-------------------------------------------
(fido-vertical-mode t)
;;; TODO: (kbd "C-v") (kbd "M-v") (kbd "M-o")

;;-------------------------------------------
;;; program options
;;-------------------------------------------
;;; electric-pair-mode
(when (fboundp 'electric-pair-mode)
  (electric-pair-mode t))

;;; compilation
(setq compile-command "make")
;;; C-u -> read command and interactive
(setq compilation-read-command t)
;; (setq compilation-auto-jump-to-first-error t)
(setq compilation-window-height 14)
(setq compilation-scroll-output t)
(setq compilation-finish-function nil)
(setq compilation-environment '("TERM=xterm-256color"))

;;; imenu
(setq imenu-flatten 'prefix)

;;; programming mode
(add-hook 'prog-mode-hook
          (lambda ()
            ;; trailing whitespace
            (setq-local show-trailing-whitespace t)
            ;; fold
            (hs-minor-mode t)
            ;; pretty symbol
            (prettify-symbols-mode t)
            ))

;;; builtin mode install
(setq auto-mode-alist
      (append
       ;; conf-mode shell-script-mode
       '((".*config\\'" . conf-mode)
         (".*profile\\'" . conf-mode)
         ("ssh.\\{1,2\\}config\\'" . conf-mode)
         ("\\.*rc\\'" . sh-mode)
         ("\\.zsh\\'" . sh-mode)
         ("\\.sh\\'" . sh-mode)
         ("\\.bash\\'" . sh-mode)
         ("\\.bashrc\\'" . sh-mode)
         ("\\.bash_history\\'" . sh-mode)
         ("\\.bash_profile\\'" . sh-mode))
       ;; log
       '(("\\.log\\'" . log-view-mode))
       ;; cc
       '(("\\.h\\'"   . c++-mode)
         ("\\.tcc\\'" . c++-mode)
         ("CMakeLists\\.txt\\'" . cmake-mode)
         ("\\.cmake\\'" . cmake-mode))
       auto-mode-alist))

;; lisp
(autoload 'enable-paredit-mode "paredit" nil t)

(dolist (hook '(emacs-lisp-mode-hook
                ielm-mode-hook
                ;; eval-expression-minibuffer-setup-hook
                scheme-mode-hook))
  (add-hook hook
            (lambda ()
              (when (package-installed-p 'paredit)
                (require 'paredit)
                (enable-paredit-mode))
              (setq-local show-paren-style 'expression))))

;;; cc
(setq-default c-default-style '((c-mode    . "linux")
                                (c++-mode  . "linux")
                                (java-mode . "java")
                                (awk-mode  . "awk")
                                (other     . "gnu"))
              c-basic-offset 4
              c-electric-pound-behavior '(alignleft)
              c-auto-newline nil
              )

(add-hook 'c-mode-hook
          (lambda ()
            (c-set-offset 'inline-open 0)))

(add-hook 'c++-mode-hook
          (lambda ()
            (c-set-offset 'inline-open 0)
            (c-set-offset 'innamespace 0)
            ;; comment
            (setq-local comment-start "/* ")
            (setq-local comment-end   " */")))

;;; python

;;-------------------------------------------
;;; package initialize
;;-------------------------------------------
;; package.el
(require 'package)

;; cancel package check signature
(setq package-check-signature nil)

;; offline package manager
(setq package-archives
      '(
        ("gnu"   . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("melpa"   . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
        ;; ("gnu"   . "http://elpa.gnu.org/elpa/gnu/")
        ;; ("melpa" . "http://melpa.org/packages/")
        ;; ("melpa-stable" . "https://mirrors.tencent.com/elpa/melpa-stable")
        ))

(unless (bound-and-true-p package--initialized)
  (package-initialize))

;;-------------------------------------------
;;; load
;;-------------------------------------------
;; emacs29 builtin use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;;-------------------------------------------
;;; evil
;;-------------------------------------------
(use-package evil :ensure t :demand t
  :config
  (evil-mode t)

  ;; set initial state
  (dolist (mode '(occur-mode
                  special-mode diff-mode
                  message-mode
                  xref--xref-buffer-mode))
    (evil-set-initial-state mode 'emacs))

  (evil-set-initial-state 'help-mode 'motion)
  (evil-define-key 'motion help-mode-map
    (kbd "TAB") 'forward-button
    (kbd "S-TAB") 'backward-button)

  ;; configure
  (setq-default evil-move-cursor-back t)
  (setq-default evil-want-C-u-scroll nil)
  (setq-default evil-symbol-word-search t)

  ;; command
  (evil-ex-define-cmd "ls" 'ibuffer)
  (evil-ex-define-cmd "nu" 'display-line-numbers-mode)

  ;; ed backward
  (define-key evil-ex-completion-map (kbd "C-b") 'backward-char)
  (define-key evil-ex-completion-map (kbd "C-f") 'forward-char)
  (define-key evil-normal-state-map (kbd "C-w u") 'winner-undo)
  (define-key evil-normal-state-map (kbd "gr") 'recentf-open)
  (define-key evil-normal-state-map (kbd "gb") 'switch-to-buffer)
  (define-key evil-normal-state-map (kbd "gl") 'ibuffer)
  (define-key evil-normal-state-map (kbd "gc") 'translate-brief-at-point)
  (define-key evil-normal-state-map (kbd "gi") 'imenu)
  (define-key evil-normal-state-map (kbd "go") 'find-file-other-window)
  (define-key evil-normal-state-map (kbd "gf")
              (lambda () (interactive)
                (if (featurep 'find-file-in-project)
                    (ffip)
                  (call-interactively #'find-file))))
  (define-key evil-normal-state-map (kbd "gs")
              (lambda () (interactive)
                (occur (format "%s" (symbol-at-point)))
                (switch-to-buffer-other-window "*Occur*")))

  (define-key evil-normal-state-map (kbd "m") nil)
  (define-key evil-normal-state-map (kbd "mm") 'core--highlight-symbol)
  (define-key evil-normal-state-map (kbd "mu") 'core--unhighlight-all-symbol)
  )

(use-package evil-surround :ensure t :after evil
  :config
  (global-evil-surround-mode t))

(use-package evil-args :ensure t :after evil
  :config
  ;; bind evil-args text objects
  (define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
  (define-key evil-outer-text-objects-map "a" 'evil-outer-arg))

;;-------------------------------------------
;;; program
;;-------------------------------------------
;;; completion
(use-package company
  :ensure t
  :defer t
  :hook (after-init . global-company-mode)
  :config
  ;; can't work with TRAMP
  (setq company-backends
        (delete 'company-ropemacs company-backends))
  (setq company-minimum-prefix-length      2)
  (setq company-tooltip-flip-when-above    t)
  (setq company-tooltip-align-annotations  t)
  (setq company-show-numbers               t)
  (setq company-clang-insert-arguments     t)
  (setq company-gtags-insert-arguments     t)
  (setq company-etags-ignore-case          nil)
  (setq company-show-numbers               t)
  (setq company-global-modes
        '(not gud-mode shell-mode eshell-mode term-mode))
  )

;;; multi edit
(use-package iedit :ensure t :defer t
  :config
  (define-key prog-mode-map (kbd "C-;") 'iedit-mode))

;; gtags
(use-package gtags-mode :ensure t :defer t
  :hook ((c-mode . gtags-mode)
         (c++-mode . gtags-mode)
         (c-ts-mode . gtags-mode)
         (c++-ts-mode . gtags-mode)))

;;; lsp server
(use-package eglot :ensure t :defer t
  :hook
  ((python-mode . eglot-ensure)
   (python-ts-mode . eglot-ensure)
   (rust-ts-mode . eglot-ensure)
   (go-ts-mode . eglot-ensure))
  :config
  (setopt eglot-report-progress nil))

;;; tree-sitter emacs29 builtin
(use-package treesit
  :if (treesit-available-p)
  :config
  (when (treesit-language-available-p 'c)
    (push '("\\.c\\'" . c-ts-mode) auto-mode-alist))
  (when (treesit-language-available-p 'cpp)
    (push '("\\.cc\\'" . c++-ts-mode) auto-mode-alist)
    (push '("\\.cpp\\'" . c++-ts-mode) auto-mode-alist))
  (when (treesit-language-available-p 'python)
    (push '("\\.py\\'" . python-ts-mode) auto-mode-alist))
  (when (treesit-language-available-p 'rust)
    (push '("\\.rs\\'" . rust-ts-mode) auto-mode-alist))
  (when (treesit-language-available-p 'go)
    (push '("\\.go\\'" . go-ts-mode) auto-mode-alist))
  (when (treesit-language-available-p 'javascript)
    (push '("\\.js\\'" . js-ts-mode) auto-mode-alist))
  (when (treesit-language-available-p 'json)
    (push '("\\.json\\'" . json-ts-mode) auto-mode-alist))
  )

;; format-all
(use-package format-all :ensure t :defer t
  :hook (prog-mode . format-all-mode))

;; lisp pair paredit
(use-package paredit :ensure t :defer t)

;;-------------------------------------------
;;; misc
;;-------------------------------------------
;;; shell
(require 'core-shell)

;;; ido sort
(use-package smex :ensure t
  :config
  (smex-initialize))

;;; wgrep
(use-package wgrep :ensure t :defer t
  :config
  (setq wgrep-enable-key "r"))

;;; which key
(use-package which-key :ensure t :defer t
  :hook (after-init . which-key-mode))

;;; git
(use-package magit :ensure t :defer t)

;;; ffip
(use-package find-file-in-project :ensure t
  :config
  (when (executable-find "fd")
    (setq ffip-use-rust-fd t)))

;;; winum
(use-package winum :ensure t
  :config
  (winum-mode t)
  (global-set-key (kbd "M-0") 'winum-select-window-0)
  (global-set-key (kbd "M-1") 'winum-select-window-1)
  (global-set-key (kbd "M-2") 'winum-select-window-2)
  (global-set-key (kbd "M-3") 'winum-select-window-3)
  (global-set-key (kbd "M-4") 'winum-select-window-4))

;;; markdown
(use-package markdown-mode :ensure t :defer t)

;;; lua
(use-package lua-mode :ensure t :defer t)

;;; exec-path-from-shell
(when *is-mac*
  (use-package exec-path-from-shell :ensure t
    :config
    (exec-path-from-shell-initialize)))

;;; consult
(use-package consult
  :config
  (global-set-key (kbd "C-s")
                  (lambda () (interactive)
                    (cond
                     ((locate-dominating-file default-directory ".git")
                      (call-interactively #'consult-git-grep))
                     ((executable-find "rg")
                      (call-interactively #'consult-ripgrep))
                     ((executable-find "grep")
                      (call-interactively #'consult-grep))
                     (t (call-interactively #'core--grep)))))
  (define-key evil-normal-state-map (kbd "gb") 'consult-buffer)
  (define-key evil-normal-state-map (kbd "gi") 'consult-imenu)
  )

;;; avy
(use-package avy
  :config
  (define-key evil-normal-state-map (kbd "M-o") 'avy-goto-line)
  ;; TODO: avy-goto-char-2
  (define-key evil-normal-state-map (kbd "C-M-o") 'avy-goto-word-0)
  )

;;-------------------------------------------
;;; chinese
;;-------------------------------------------
(use-package pyim :ensure t :defer t
  :config
  (require 'pyim)
  (setq default-input-method "pyim")
  (setq pyim-default-scheme 'quanpin)
  (setq pyim-page-length 9)

  (when (package-installed-p 'posframe)
    (require 'posframe)
    (setq pyim-page-tooltip 'posframe)))

(use-package pyim-basedict :ensure t :defer t
  :after pyim
  :config
  (require 'pyim-basedict)
  (pyim-basedict-enable))

(use-package bing-dict :ensure t :defer t)

(defun translate-brief-at-point ()
  (interactive)
  (let ((word (if (use-region-p)
                  (buffer-substring-no-properties
                   (region-beginning) (region-end))
                (thing-at-point 'word t))))
    (if word
        (bing-dict-brief word)
      (message "No Word."))))

;; emacs sometimes can't reconginze gbk
;; set coding config, last is highest priority.
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Recognize-Coding.html#Recognize-Coding
(prefer-coding-system 'cp950)
(prefer-coding-system 'gb2312)
(prefer-coding-system 'cp936)
(prefer-coding-system 'gb18030)
(prefer-coding-system 'utf-16)
(prefer-coding-system 'utf-8-dos)
(prefer-coding-system 'utf-8-unix)

;;; only a little
;; (when (eq system-type 'windows-nt)
;;   (prefer-coding-system 'gbk)
;;   (set-default-coding-systems 'gbk))

;;-------------------------------------------
;;; initialize end
;;-------------------------------------------
;; custom file
(setq custom-file (expand-file-name ".custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;;; server start
(unless (eq system-type 'windows-nt)
  (require 'server)
  (unless (server-running-p)
    (server-start)))

(provide 'init)
