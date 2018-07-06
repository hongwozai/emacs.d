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
   '("typeof" "__attribute__" "__asm__"
     ("\\<\\(FIXME\\|NOTE\\|TODO\\):" 1 'font-lock-warning-face prepend)
     ("->\\|,\\|=\\|!\\|>\\|<\\|>=\\|<=\\|^\\|*\\|-\\|+\\|\\.\\|/\\|::\\|&"
      .
      'font-lock-builtin-face)))

  ;; flycheck
  (setq-local flycheck-clang-language-standard "c++11")
  )

;;; install
(dolist (hook '(c-mode-hook c++-mode-hook))
  (add-hook 'c-mode-common-hook #'cc-basic-config))

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
  ("z" (lambda () (interactive) (pop-to-buffer gud-comint-buffer)))
  ("q" nil "quit"))

;;-------------------------------------------
;;; cquery
;;-------------------------------------------
(require-package 'cquery)
(autoload 'lsp-cquery-enable "cquery")
(setq cquery-extra-init-params '(:cacheFormat "msgpack"))

;;-------------------------------------------
;;; packaging
;;-------------------------------------------
(defun ide-feature-enable ()
  (interactive)
  (lsp-cquery-enable))

(add-hook 'c-mode-common-hook
          #'(lambda () (ignore-errors (lsp-cquery-enable))))
