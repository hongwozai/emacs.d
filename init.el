;;; -*- coding: utf-8 -*-

;;-------------------------------------------
;;; custom ui
;;-------------------------------------------
(when *is-mac*
  (set-face-attribute 'default nil :font "Menlo 18")
  (setq mac-option-modifier 'meta))

(when (eql system-type 'gnu/linux)
  (set-face-attribute 'default nil :font "DejaVu Sans Mono Bold 16"))

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

(setq grep-command
      (cond ((executable-find "rg") "rg --no-heading -w ")
            ((executable-find "ag") "ag --nogroup --noheading ")
            (t "grep --binary-files=without-match -nH -r -E -e ")))

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
  (define-key dired-mode-map "F" 'ffip)
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
            (hl-line-mode 1)))

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

;;; programming mode
(add-hook 'prog-mode-hook
          (lambda ()
            ;; trailing whitespace
            (setq-local show-trailing-whitespace t)
            ;; fold
            (hs-minor-mode t)
            ;;; pretty symbol
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
(setq python-shell-interpreter "python3")

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
  :hook
  ((occur-mode . evil-emacs-state)
   (special-mode . evil-emacs-state)
   (xref-mode . evil-emacs-state)
   (help-mode . evil-motion-state)
   (message-mode . evil-emacs-state))
  :config
  (evil-mode t)

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
  (define-key evil-normal-state-map (kbd "gf")
              (lambda () (interactive)
                (if (featurep 'find-file-in-project)
                    (ffip)
                  (call-interactively #'find-file))))
  (define-key evil-normal-state-map (kbd "gs")
              (lambda () (interactive)
                (occur (format "%s" (symbol-at-point)))
                (switch-to-buffer-other-window "*Occur*")))
  (define-key evil-normal-state-map (kbd "gi") 'imenu)
  )

(use-package evil-surround :ensure t :after evil
  :config
  (global-evil-surround-mode t))

(use-package evil-args :ensure t :after evil
  :config
  ;; bind evil-args text objects
  (define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
  (define-key evil-outer-text-objects-map "a" 'evil-outer-arg))

(use-package evil-matchit :ensure t :after evil)

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
  (setq company-minimum-prefix-length      3)
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
(define-key prog-mode-map (kbd "C-;") 'iedit-mode)
(use-package iedit :ensure t :defer t)

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
(use-package tree-sitter
  :if (treesit-available-p)
  :defer t
  :mode
  (("\\.c\\'" . c-ts-mode)
   ("\\.h\\'"   . c++-ts-mode)
   ("\\.cc\\'" . c++-ts-mode)
   ("\\.cpp\\'" . c++-ts-mode)
   ("\\.py\\'" . python-ts-mode)
   ("\\.go\\'" . go-ts-mode)
   ("\\.rs\\'" . rust-ts-mode)
   ("\\.java\\'" . java-ts-mode)
   ("\\.ts\\'" . typescript-ts-mode)
   ("\\.js\\'" . js-ts-mode)
   )
  :config
  (setq treesit-language-source-alist
        '((bash "https://github.com/tree-sitter/tree-sitter-bash")
          (c "https://github.com/tree-sitter/tree-sitter-c")
          (cmake "https://github.com/uyha/tree-sitter-cmake")
          (common-lisp "https://github.com/theHamsta/tree-sitter-commonlisp")
          (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
          (css "https://github.com/tree-sitter/tree-sitter-css")
          (csharp "https://github.com/tree-sitter/tree-sitter-c-sharp")
          (elisp "https://github.com/Wilfred/tree-sitter-elisp")
          (go "https://github.com/tree-sitter/tree-sitter-go")
          (go-mod "https://github.com/camdencheek/tree-sitter-go-mod")
          (html "https://github.com/tree-sitter/tree-sitter-html")
          (js . ("https://github.com/tree-sitter/tree-sitter-javascript" "master" "src"))
          (json "https://github.com/tree-sitter/tree-sitter-json")
          (lua "https://github.com/Azganoth/tree-sitter-lua")
          (make "https://github.com/alemuller/tree-sitter-make")
          (markdown "https://github.com/ikatyang/tree-sitter-markdown")
          (python "https://github.com/tree-sitter/tree-sitter-python")
          (r "https://github.com/r-lib/tree-sitter-r")
          (rust "https://github.com/tree-sitter/tree-sitter-rust")
          (toml "https://github.com/tree-sitter/tree-sitter-toml")
          (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
          (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))
          (yaml "https://github.com/ikatyang/tree-sitter-yaml")))
  (mapc #'treesit-install-language-grammar
        (mapcar #'car treesit-language-source-alist))
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
(use-package smex :ensure t :defer t)

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
(use-package find-file-in-project :ensure t)

;;; winum
(use-package winum :ensure t
  :config
  (winum-mode t)
  (global-set-key (kbd "M-0") 'winum-select-window-0)
  (global-set-key (kbd "M-1") 'winum-select-window-1)
  (global-set-key (kbd "M-2") 'winum-select-window-2)
  (global-set-key (kbd "M-3") 'winum-select-window-3)
  (global-set-key (kbd "M-4") 'winum-select-window-4))

;;-------------------------------------------
;;; initialize end
;;-------------------------------------------
;; custom file
(setq custom-file (expand-file-name ".custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;;; server start
(require 'server)
(unless (server-running-p)
  (server-start))

(provide 'init)
