;;; package
(require 'package)

;; cancel package check signature
(setq package-check-signature nil)

;;; touch ~/.emacs.d/offline -> offline config
(if (file-exists-p
     (expand-file-name "offline" user-emacs-directory))
    ;; offline
    (setq package-archives
          `(("localelpa" .
             ,(expand-file-name "localelpa" user-emacs-directory))))
  ;; online
  (setq package-archives
        '(("gnu"   . "https://mirrors.tencent.com/elpa/gnu/")
          ("melpa" . "https://mirrors.tencent.com/elpa/melpa/")
          ;; ("melpa-stable" . "https://mirrors.tencent.com/elpa/melpa-stable")
          )))

;;; offical Melpa (and Gnu)
;;; ("melpa" . "http://melpa.org/packages/")
;;; ("melpa-stable" . "http://stable.melpa.org/packages/")


;;-------------------------------------------
;;; quelpa install from source
;;-------------------------------------------
(require 'quelpa)
(setq quelpa-update-melpa-p nil)

;;-------------------------------------------
;;; package func
;;-------------------------------------------
(defun require-package (package &optional no-refresh)
  "Install given PACKAGE. "
  (if (package-installed-p package)
      t
    (if (eq core/package-install-mode 'source)
        (quelpa package)
      (if (or (assoc package package-archive-contents)
              no-refresh)
          (package-install package)
        (progn
          (package-refresh-contents)
          (require-package package t))))))

(font-lock-add-keywords 'emacs-lisp-mode
                        '("require-package" "maybe-require"))

(defun core/local-mirror-install ()
  (interactive)
  (when (require 'elpa-mirror nil t)
    (let ((elpamr-default-output-directory
           (expand-file-name "localelpa" user-emacs-directory)))
      (elpamr-create-mirror-for-installed))))

;;-------------------------------------------
;;; compile local site-lisp
;;-------------------------------------------
(defun core/compile-site-lisp-files ()
  (interactive)
  (let* ((default-directory
           (expand-file-name "site-lisp" user-emacs-directory))
         (files (directory-files default-directory)))
    (mapc (lambda (file)
            (when (string-suffix-p ".el" file)
              (unless (file-exists-p (concat file "c"))
                (byte-compile-file file))))
          files)))

;;; compile site-lisp
(core/compile-site-lisp-files)

(provide 'core-package)
