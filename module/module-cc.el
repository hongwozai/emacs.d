;;-------------------------------------------
;;; cc mode common
;;-------------------------------------------
(setq-default c-default-style '((c-mode    . "linux")
                                (c++-mode  . "linux")
                                (java-mode . "java")
                                (awk-mode  . "awk")
                                (other     . "gnu"))
              c-basic-offset 4)

;; indent (# left align)
(setq-default c-electric-pound-behavior '(alignleft))
;;-------------------------------------------
;;; basic option
;;-------------------------------------------
(defun cc-basic-config ()
  "C/C++ both config"

  (c-set-offset 'inline-open 0)

  ;; related file
  (setq-local cc-search-directories
              '("." ".."
                "../inc" "../Inc"
                "../include" "../Include"
                "../src" "../source"
                "../Src" "../Source"
                "/usr/include" "/usr/local/include/"))

  ;; keywords (poor performance!)
  ;; (font-lock-add-keywords
  ;;  nil
  ;;  '(
  ;;    ("\\<\\(FIXME\\|NOTE\\|TODO\\|TBD\\):" 1 'font-lock-warning-face prepend)
  ;;    "typeof" "__attribute__" "__asm__"
  ;;    ))

  ;; keybindings
  (local-set-key (kbd "C-c C-c") 'compile)

  ;; company
  (setq-local company-backends
              '(company-capf
                company-files
                (company-dabbrev-code
                 company-gtags
                 company-etags
                 company-dabbrev)))

  ;; flycheck
  (setq-local flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))

  ;; hideif
  ;; (setq hide-ifdef-shadow t)
  ;; (hide-ifdef-mode)
  )

(defun c++-config ()
  ;; indent
  (c-set-offset 'innamespace 0)
  ;; flycheck
  (setq-local flycheck-clang-language-standard "c++11")
  ;; comment
  (setq-local comment-start "/* ")
  (setq-local comment-end   " */")
  )

;;; install
(dolist (hook '(c-mode-hook c++-mode-hook))
  (add-hook hook #'cc-basic-config))

(add-hook 'c++-mode-hook #'c++-config)

;;; .h -> c++-mode
(add-to-list 'auto-mode-alist '("\\.h\\'"   . c++-mode))
(add-to-list 'auto-mode-alist '("\\.tcc\\'" . c++-mode))

;;-------------------------------------------
;;; gdb
;;-------------------------------------------
;; Force gdb-mi to not dedicate any windows
(advice-add 'gdb-display-buffer
            :around (lambda (orig-fun &rest r)
                      (let ((window (apply orig-fun r)))
                        (set-window-dedicated-p window nil)
                        window)))

(advice-add 'gdb-set-window-buffer
            :around (lambda (orig-fun name &optional ignore-dedicated window)
                      (funcall orig-fun name ignore-dedicated window)
                      (set-window-dedicated-p window nil)))

;;-------------------------------------------
;;; hideif-mode
;;-------------------------------------------
(defun ifdef-parse-dbfile (filename)
  (interactive "f")
  ;; clear
  (setq hide-ifdef-env-backup hide-ifdef-env)
  (setq hide-ifdef-env nil)
  ;; set macro
  (let ((json-obj (json-read-file filename))
        assoc-list)
    (mapc
     (lambda (file-obj)
       (let ((arg-obj (cdr (assoc 'arguments file-obj)))
             (cmd-obj (cdr (assoc 'command   file-obj))))
         (when cmd-obj (error "Not Implement!"))
         ;; for arg to set assoc-list
         (mapc (lambda (arg)
                 (when (string-match "^-D\\([^=]*\\)=?\"?\\([^\"]*\\)\"?"
                                     arg)
                   (let ((m1 (match-string 1 arg))
                         (m2 (match-string 2 arg)))
                     (when m1
                       (unless (assoc m1 assoc-list)
                         (hif-set-var (intern m1) m2)
                         (push (cons m1 m2) assoc-list))))))
               arg-obj)))
     json-obj)
    (setq hide-ifdef-initially t)
    (if hide-ifdef-hiding (hide-ifdefs t))
    ))

;;-------------------------------------------
;;; style
;;-------------------------------------------
;;; google-style
(autoload 'google-set-c-style "google-c-style" "c style" t)
(autoload 'google-make-newline-indent "google-c-style" "c style" t)

(setq google-style-project nil)

(defun my-google-set-c-style ()
  (interactive)
  (when google-style-project
    (google-set-c-style)
    (google-make-newline-indent))
  )

;;-------------------------------------------
;;; mode
;;-------------------------------------------
(require-package 'cmake-mode)

(setq auto-mode-alist
      (append
       ;; cmake
       '(("CMakeLists\\.txt\\'" . cmake-mode)
         ("\\.cmake\\'" . cmake-mode))
       auto-mode-alist))

;;; company-clang error message annoying
(with-eval-after-load 'company-clang
  (advice-add 'company-clang--handle-error
              :around
              (lambda (func &rest args)
                (let ((inhibit-message t))
                  (apply func args)))))

;;-------------------------------------------
;;; lsp
;;-------------------------------------------
(when (executable-find "ccls")
  (setq lsp-clients-clangd-executable "ccls"))

;;; ccls configure
(setq ccls-initialization-options
      '(:index (:comments 2) :completion (:detailedLabel t)))

(setq lsp-enable-symbol-highlighting nil)
;; (setq ccls-sem-highlight-method 'font-lock)

(setq enable-lsp-project nil)

(defun enable-lsp ()
  (when enable-lsp-project
    (setq-local flycheck-disabled-checkers
                '(c/c++-clang c/c++-cppcheck c/c++-gcc))
    ;; ccls
    ;; (when (package-installed-p 'ccls)
    ;;   (require 'ccls))
    (lsp)))

(add-hook 'c-mode-local-vars-hook #'enable-lsp)
(add-hook 'c++-mode-local-vars-hook #'enable-lsp)

(add-hook 'c-mode-local-vars-hook #'my-google-set-c-style)
(add-hook 'c++-mode-local-vars-hook #'my-google-set-c-style)
