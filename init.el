;;; -*- coding: utf-8 -*-

;;-------------------------------------------
;;; custom variable
;;-------------------------------------------
;;; set user home
(setq user-home-directory
      (file-name-as-directory (expand-file-name "~")))

;;; startup default directory
(setq default-directory user-home-directory)

;;; add sub directory to load-path
(dolist (name '("site-lisp"))
  (add-to-list 'load-path
               (expand-file-name name user-emacs-directory)))

(setq *is-mac* (eql system-type 'darwin))
(setq *is-win* (eql system-type 'windows-nt))

(setq debug-on-error t)
(setq debug-on-quit nil)

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

(when (eq system-type 'gnu/linux)
  (set-face-attribute 'default nil :font "DejaVu Sans Mono Bold 16"))

(when *is-win*
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

;; theme
(ignore-errors (load-theme 'leuven t))

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
                "["
                (:eval (if-let (proj (project-current))
                           (project-name proj)))
                (vc-mode vc-mode)
                "]"
                "  "
                mode-line-modes
                mode-line-misc-info
                mode-line-end-spaces))

;;; purge minor mode
(defvar show-minor-modes '(iedit-mode flymake-mode vc-dir-git-mode))

(defun purge-minor-modes ()
  (setf minor-mode-alist
        (mapcar
         #'(lambda (x)
             (if (member (car x) show-minor-modes)
                 x
               (list (car x) "")))
         minor-mode-alist)))

(add-hook 'after-change-major-mode-hook 'purge-minor-modes)

;;-------------------------------------------
;;; basic option
;;-------------------------------------------
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
(setq minibuffer-message-timeout nil)

;; Auto refresh buffers, dired revert have bugs.
;;; remote file revert have bugs.
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t
      dired-auto-revert-buffer            nil
      auto-revert-verbose                 nil)

;;; recent files
(setq recentf-filename-handlers 'abbreviate-file-name)
(setq recentf-max-saved-items 100)
(setq recentf-exclude '(".*\\.png$" ".*\\.gz$" ".*\\.jpg$"
                        "GTAGS" "TAGS" "^tags$" ".*pyim.*"))
(add-hook 'after-init-hook #'recentf-mode)

;; open files
(global-set-key (kbd "M-g r") 'recentf-open)
(global-set-key (kbd "M-g o") 'find-file-other-window)

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

;;-------------------------------------------
;;; tramp
;;-------------------------------------------
;;; ssh is faster than scp. scpx or sshx. see Tramp hangs
(if (and *is-win* (executable-find "plink"))
    (setq tramp-default-method "plink")
  (setq tramp-default-method "ssh"))

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
  (require 'dired-x)
  ;; diredp
  (setq dired-recursive-copies   'always)
  (setq dired-recursive-deletes  'always)
  (setq dired-isearch-filenames  t)
  (setq dired-dwim-target        t)
  (if *is-mac*
      (setq dired-listing-switches "-aluh")
    (setq dired-listing-switches "-aluh --time-style=iso"))

  ;; key
  (define-key dired-mode-map (kbd ")") 'dired-omit-mode)
  (define-key dired-mode-map [mouse-2] 'dired-find-file)
  (define-key dired-mode-map "n" 'evil-search-next)
  (define-key dired-mode-map "N" 'evil-search-previous)
  )

(add-hook 'dired-mode-hook
          (lambda ()
            (setq-local truncate-lines t)
            (setq dired-omit-verbose nil)
            (setq dired-omit-files "^\\.?#\\|^\\..?$\\|^\\.[^.]?.+$")
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
(defun --region-or-point (thing)
  (if (use-region-p)
      (buffer-substring-no-properties
       (region-beginning) (region-end))
    (thing-at-point thing t)))

(defun --minibuffer-insert-at-point ()
  (interactive)
  (let ((sym (with-selected-window (minibuffer-selected-window)
               (--region-or-point 'symbol))))
    (with-current-buffer (current-buffer)
      (insert (format "%s" (or sym ""))))))

(defun --isearch-insert-at-point ()
  "Pull next word from buffer into search string."
  (interactive)
  (let ((query (with-current-buffer (current-buffer)
                 (format "%s" (--region-or-point 'symbol)))))
    (isearch-yank-string query)))

(defun --occur-at-point ()
  (interactive)
  (let ((query (--region-or-point 'symbol)))
    (occur query)
    (switch-to-buffer-other-window "*Occur*")))

(defun --project-grep (query)
  (interactive
   (list (read-shell-command
          "Project Grep: "
          (--region-or-point 'symbol))))
  (let* ((root (project-root (project-current)))
         (path (file-relative-name root default-directory))
         (is-git (locate-dominating-file default-directory ".git")))
    (cond
     (is-git
      (grep (format "git --no-pager grep -n -i -e \"%s\" %s" query path)))
     ((executable-find "rg")
      (grep (format "rg -n --no-heading -w \"%s\" %s" query path)))
     (t (grep
         (format
          "grep --binary-files=without-match -nH -r -E -e \"%s\" %s"
          query path))))
    (switch-to-buffer-other-window "*grep*")))

;; current buffer search
(define-key minibuffer-local-map (kbd "M-.") '--minibuffer-insert-at-point)
(define-key isearch-mode-map (kbd "M-.") '--isearch-insert-at-point)
(define-key isearch-mode-map (kbd "M-o") 'isearch-occur)

;; current buffer occur
(global-set-key (kbd "M-s o") '--occur-at-point)
(global-set-key (kbd "M-s O") 'occur)

;; current project grep
(global-set-key (kbd "M-s g") '--project-grep)

;;-------------------------------------------
;;; highlight
;;-------------------------------------------
(defun --highlight-symbol ()
  (interactive)
  (require 'hi-lock)
  (let ((regexp (find-tag-default-as-symbol-regexp)))
    (if (assoc regexp hi-lock-interactive-lighters)
        (unhighlight-regexp regexp)
      (highlight-symbol-at-point))))

(defun --unhighlight-all-symbol ()
  (interactive)
  (unhighlight-regexp t))

(global-set-key [remap highlight-symbol-at-point] '--highlight-symbol)
(global-set-key (kbd "M-s h U") '--unhighlight-all-symbol)

;;-------------------------------------------
;;; interactive
;;-------------------------------------------
(if (version< emacs-version "29.0")
    (progn (ido-mode t)
           (ido-everywhere 1))
  (progn
    (fido-vertical-mode t)))
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
(unless *is-win*
  (setq compilation-environment '("TERM=xterm-256color")))

;;; imenu
(require 'imenu-flatter)
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

;;; eldoc
(setq eldoc-echo-area-use-multiline-p 3)

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
(dolist (hook '(emacs-lisp-mode-hook
                ielm-mode-hook
                eval-expression-minibuffer-setup-hook
                scheme-mode-hook))
  (add-hook hook
            (lambda ()
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

;; (setq package-archives
;;       '(("melpa" . "https://raw.githubusercontent.com/d12frosted/elpa-mirror/master/melpa/")
;;         ("org"   . "https://raw.githubusercontent.com/d12frosted/elpa-mirror/master/org/")
;;         ("gnu"   . "https://raw.githubusercontent.com/d12frosted/elpa-mirror/master/gnu/")))

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
  (dolist (mode '(occur-mode diff-mode message-mode
                             xref--xref-buffer-mode))
    (evil-set-initial-state mode 'emacs))

  ;; special
  (evil-set-initial-state 'special-mode 'motion)

  ;; help-mode
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
  (define-key evil-normal-state-map (kbd "C-p") project-prefix-map)
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
(use-package company :ensure t :defer t
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

;; jump windows
(use-package ace-window :ensure t :defer t
  :init
  (global-set-key (kbd "M-o") 'ace-window))

;;; multi edit
(use-package iedit :ensure t :defer t
  :init
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
  :if (and (featurep 'treesit) (treesit-available-p))
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

;;-------------------------------------------
;;; misc
;;-------------------------------------------
;;; shell
(require 'shell-config)

;;; wgrep
(use-package wgrep :ensure t :defer t
  :init
  (setq wgrep-enable-key "r"))

;;; which key
(use-package which-key :ensure t :defer t
  :hook (after-init . which-key-mode))

;;; git
(use-package magit :ensure t :defer t)

;;; markdown
(use-package markdown-mode :ensure t :defer t)

;;; lua
(use-package lua-mode :ensure t :defer t)

;;; exec-path-from-shell
(when *is-mac*
  (use-package exec-path-from-shell :ensure t
    :config
    (exec-path-from-shell-initialize)))

;;-------------------------------------------
;;; chinese
;;-------------------------------------------
(use-package pyim :ensure t :defer t
  :init
  (setq default-input-method "pyim")
  (setq pyim-default-scheme 'quanpin)
  (setq pyim-page-length 9)

  (when (package-installed-p 'posframe)
    (require 'posframe)
    (setq pyim-page-tooltip 'posframe)))

(use-package pyim-basedict :ensure t :defer t
  :after pyim
  :config
  (pyim-basedict-enable))

(use-package bing-dict :ensure t :defer t)

(defun translate-brief-at-point ()
  (interactive)
  (let ((word (--region-or-point 'word)))
    (if word
        (bing-dict-brief word)
      (message "No Word."))))

(global-set-key (kbd "M-s c") 'translate-brief-at-point)

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

(when *is-win*
  (prefer-coding-system 'gbk))

;;-------------------------------------------
;;; initialize end
;;-------------------------------------------
;; custom file
(setq custom-file (expand-file-name ".custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

(when (daemonp)
  (add-hook 'server-after-make-frame-hook
            (lambda ()
              (set-graphic-font '("DejaVu Sans Mono Bold" . 16)
                                '("微软雅黑" . 20)))))

(provide 'init)
