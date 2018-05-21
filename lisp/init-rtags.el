(require-package 'rtags)
(require-package 'flycheck-rtags)
(require-package 'company-rtags)
(require-package 'ivy-rtags)

;;; cmake
;;; cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 . && rc -J
;;; make
;;; make -B -nk | rc -c -
(setq rtags-display-result-backend 'ivy)

(defun hong/flycheck-rtags-install ()
  (require 'flycheck-rtags)
  (flycheck-select-checker 'rtags)
  (setq-local flycheck-highlighting-mode nil)
  (setq-local flycheck-check-syntax-automatically nil))

(defun hong/company-rtags-install ()
  (require 'company-rtags)
  (push 'company-rtags company-backends))

(defun hong/install-rtags ()
  "Start Use Rtags"
  (interactive)
  (require 'rtags)
  (require 'ivy-rtags)

  (rtags-start-process-unless-running)

  (dolist (hook '(c-mode-hook c++-mode-hook))
    (add-hook
     hook
     (lambda ()
       ;; checker complete
       (hong/flycheck-rtags-install)
       (hong/company-rtags-install)

       ;; keybinding
       (dolist (mode '(c-mode c++-mode))
         (evil-leader/set-key-for-mode mode
             "im" 'rtags-imenu
             "gd" 'rtags-find-symbol-at-point
             "gr" 'rtags-find-all-references-at-point
             "gs" 'rtags-find-symbol
             "gc" 'hong/rtags-generate-index
             "gp" 'rtags-location-stack-back))

       (dolist (map '(c-mode-map c++-mode-map))
         (eval `(evil-define-key 'normal ,map
                  (kbd "M-.") 'rtags-find-symbol-at-point
                  (kbd "M-,") 'rtags-location-stack-back
                  (kbd "M-?") 'rtags-display-summary)))
       )))
)

(defun hong/rtags-generate-index (&optional dir)
  (interactive)
  (let* ((make-cmd
          "make -nBk | awk -f ~/.emacs.d/oneline.awk | grep -E '^(g\+\+|gcc|clang)' | rc -c -")
         (cmake-cmd "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 . && rc -J")
         (dir
          (file-name-as-directory
           (if (or (not dir) current-prefix-arg)
               (read-directory-name "Directory: ")
             dir)))
         (default-directory dir)
         (ismake (or (file-exists-p (concat dir "makefile"))
                     (file-exists-p (concat dir "Makefile"))))
         (iscmake (file-exists-p (concat dir "CMakeLists.txt")))
         (cmd-buffer "*cmd*")
         ret)
    (if iscmake
        (setq ret (shell-command cmake-cmd cmd-buffer cmd-buffer))
      (if ismake
          (setq ret (shell-command make-cmd cmd-buffer cmd-buffer))
        (error "Not Make or CMake Project!")))
    (if (and (>= ret 0)
             (= 0 (length (save-window-excursion
                            (switch-to-buffer cmd-buffer)
                            (buffer-string)))))
        (message "Success.")
      (message "Failure."))))

;;; rtags-start-process-unless-running
;;; rtags-find-symbol-at-point
;;; rtags-imenu
;;; rtags-display-summary
;;; rtags-find-reference-at-point
;;; rtags-location-stack-back
;;; rtags-print-source-argument

(provide 'init-rtags)
