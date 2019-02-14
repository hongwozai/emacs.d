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

  ;; keywords
  (font-lock-add-keywords
   nil
   '(
     ("\\<\\(FIXME\\|NOTE\\|TODO\\|TBD\\):" 1 'font-lock-warning-face prepend)
     "typeof" "__attribute__" "__asm__"
     ))

  ;; keybindings
  (local-set-key (kbd "C-c C-c") 'compile)

  ;; company
  (setq-local company-backends
              '(company-capf
                company-gtags
                company-etags
                company-dabbrev))

  ;; flycheck
  (setq-local flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
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

(defhydra hydra-gud (:color amaranth)
  ;; vi
  ("h" backward-char)
  ("j" next-line)
  ("k" previous-line)
  ("l" forward-char)
  ;; gud
  ("t" gud-tbreak "tbreak")
  ("b" gud-break "break")
  ("d" gud-remove "nbr")
  ("p" gud-print "print" :color blue)
  ("m" gud-until "move")
  ("n" gud-next "next")
  ("c" gud-cont "cont")
  ("o" gud-finish "out")
  ("r" gud-run "run")
  ("q"
   (lambda () (interactive) (pop-to-buffer gud-comint-buffer))
   :color blue))

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

(defun enable-lsp ()
  (setq-local flycheck-disabled-checkers
              '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  (lsp))

(defun enable-cc-lsp ()
  (interactive)
  (add-hook 'c++-mode-hook #'enable-lsp))

(defun disable-cc-lsp ()
  (interactive)
  (remove-hook 'c++-mode-hook #'enable-lsp))